/*
    Copyright (C) 2020  Carson Black

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

extern crate rand;
extern crate regex;

use rand::Rng; 
use rand::distributions::Alphanumeric;

use librsvg;
use cairo;

use std::str;
use std::fs;
use std::process::Command;
use std::error::Error;
use std::collections::HashMap;

use regex::Regex;

/// Object that exposes Ikona's icon manipulation functionality.
/// 
/// This is the entrypoint for Ikona's functionality.
#[repr(C)]
pub struct IkonaIcon {
    handle: librsvg::SvgHandle,
    filepath: String,
}
macro_rules! stylesheet_replace {
    ($icon: ident, $stylesheet: ident, $color: tt, $class: tt) => {
        let color_format = format!("fill=\"{}\"", $color);
        let replace_format = format!("fill=\"currentColor\" class=\"ColorScheme-{}\"", $class);
        let stylesheet_format = format!(".ColorScheme-{} {{ color: {}; }}", $class, $color);

        if $icon.contains(&color_format) {
            $icon = $icon.replace(&color_format, &replace_format);
            $stylesheet.push_str(&stylesheet_format);
        }
    };
}
impl IkonaIcon {
    /// Creates an `IkonaIcon`, reading the contents from `in_path`.
    /// 
    /// # Example:
    /// 
    /// ```ignore
    /// use ikona::icons::IkonaIcon;
    /// 
    /// let icon = IkonaIcon::new_from_path("example.svg").unwrap();
    /// ```
    pub fn new_from_path(in_path: String) -> Result<IkonaIcon, String> {
        match librsvg::Loader::new().read_path(in_path.clone()) {
            Ok(handle) => Ok(IkonaIcon{handle: handle, filepath: in_path}),
            Err(_) => Err("There was an error loading the SVG".to_string()),
        }
    }
    /// Creates an `IkonaIcon`, reading the contents from a String. 
    /// 
    /// # Example: 
    /// 
    /// ```
    /// use ikona::icons::IkonaIcon;
    /// 
    /// let icon = IkonaIcon::new_from_string("<svg></svg>").unwrap();
    /// ```
    pub fn new_from_string(string: String) -> Result<IkonaIcon, String> {
        let filepath = format!("/tmp/ikona-{}.svg", rand::thread_rng()
            .sample_iter(&Alphanumeric)
            .take(40)
            .collect::<String>());

        match fs::write(filepath.clone(), string) {
            Ok(_) => {
                match librsvg::Loader::new().read_path(filepath.clone()) {
                    Ok(handle) => Ok(IkonaIcon{handle: handle, filepath: filepath}),
                    Err(_) => Err("There was an error loading the SVG".to_string())
                }
            },
            Err(_) => Err("There was an error creating an internal file".to_string())
        }
    }
    /// Reads the filepath of an `IkonaIcon` into a `String`.
    /// 
    /// # Example:
    /// ```
    /// use ikona::icons::IkonaIcon;
    /// 
    /// let icon = IkonaIcon::new_from_string("<svg></svg>").unwrap();
    /// 
    /// let filepath = icon.get_filepath();
    /// ````
    pub fn get_filepath(&self) -> String {
        self.filepath.clone()
    }
    /// Optimizes the SVG of the current `IkonaIcon` with rsvg and returns it
    /// as a new `IkonaIcon`.
    /// 
    /// # Example:
    /// ```
    /// use ikona::icons::IkonaIcon;
    /// 
    /// let icon = IkonaIcon::new_from_string("<svg></svg>").unwrap();
    /// 
    /// let optimized = icon.optimize_with_rsvg().unwrap();
    /// ````
    pub fn optimize_with_rsvg(&self) -> Result<IkonaIcon, String> {
        let renderer = librsvg::CairoRenderer::new(&self.handle);

        let filepath = format!("/tmp/ikona-{}.svg", rand::thread_rng()
                        .sample_iter(&Alphanumeric)
                        .take(40)
                        .collect::<String>());

        let width = f64::from(
            match renderer.intrinsic_dimensions().width {
                Some(val) => val.length,
                None => return Err("Failed to get width".to_string())
            }
        );

        let height = f64::from(
            match renderer.intrinsic_dimensions().height {
                Some(val) => val.length,
                None => return Err("Failed to get height".to_string())
            }
        );

        let svg_surface = cairo::SvgSurface::new(width, height, filepath.clone());
        
        let cairo_context = cairo::Context::new(&svg_surface);

        match renderer.render_document(&cairo_context, &cairo::Rectangle{x:0.0,y:0.0,width:width,height:height}) {
            Err(_) => Err("Failed to render SVG".to_string()),
            Ok(_) => {
                svg_surface.finish();

                return IkonaIcon::new_from_path(filepath);
            }
        }
    }
    /// Optimizes the SVG of the current `IkonaIcon` with scour and returns it
    /// as a new `IkonaIcon`.
    /// 
    /// # Example:
    /// ```
    /// use ikona::icons::IkonaIcon;
    /// 
    /// let icon = IkonaIcon::new_from_string("<svg></svg>").unwrap();
    /// 
    /// let optimized = icon.optimize_with_scour().unwrap();
    /// ````
    pub fn optimize_with_scour(&self) -> Result<IkonaIcon, String> {
        let output = match Command::new("scour")
                                    .arg("--set-precision=8")
                                    .arg("--enable-viewboxing")
                                    .arg("--enable-comment-stripping")
                                    .arg("--remove-descriptive-elements")
                                    .arg("--create-groups")
                                    .arg("--strip-xml-space")
                                    .arg("--strip-xml-prolog")
                                    .arg("--nindent=4")
                                    .arg("--quiet")
                                    .arg(self.filepath.clone())
                                    .output() {
            Ok(res) => res,
            Err(_) => return Err("Failed to get scour output".to_string()),
        };
        if output.status.code().unwrap() != 0 {
            return Err("Scour failed to parse icon".to_string());
        }
        
        let string = String::from_utf8_lossy(&output.stdout).into_owned();

        return IkonaIcon::new_from_string(string);
    }
    /// Optimizes the SVG of the current `IkonaIcon` with both rsvg and scour
    /// and returns it as a new `IkonaIcon`.
    /// 
    /// # Example:
    /// ```
    /// use ikona::icons::IkonaIcon;
    /// 
    /// let icon = IkonaIcon::new_from_string("<svg></svg>").unwrap();
    /// 
    /// let optimized = icon.optimize_all().unwrap();
    /// ````
    pub fn optimize_all(&self) -> Result<IkonaIcon, String> {
        match self.optimize_with_rsvg() {
            Ok(ok) => {
                match ok.optimize_with_scour() {
                    Ok(ok) => Ok(ok),
                    Err(err) => Err(err),
                }
            },
            Err(err) => Err(err),
        }
    }
    /// Returns an child `IkonaIcon` extracted by ID and size.
    pub fn extract_subicon_by_id(&self, id: &str, target_size: i32) -> Result<IkonaIcon, String> {
        match self.handle.has_element_with_id(id) {
            Ok(_) => {
                let renderer = librsvg::CairoRenderer::new(&self.handle);

                let filepath = format!("/tmp/ikona-{}.svg", rand::thread_rng()
                    .sample_iter(&Alphanumeric)
                    .take(40)
                    .collect::<String>());

                let mut svg_surface = cairo::SvgSurface::new(f64::from(target_size), f64::from(target_size), filepath.clone());
                svg_surface.set_document_unit(cairo::SvgUnit::Px);

                let cairo_context = cairo::Context::new(&svg_surface);

                match renderer.render_element(&cairo_context, Some(id), &cairo::Rectangle{ x: 0.0,  y: 0.0, width: f64::from(target_size), height: f64::from(target_size) }) {
                    Err(_) => Err("Failed to render sub icon".to_string()),
                    Ok(_) => {
                        svg_surface.finish();

                        return IkonaIcon::new_from_path(filepath);
                    },
                }
            },
            Err(_) => Err("Badly formatted ID, or SVG does not have ID".to_string()),
        }
    }
    /// Returns an child `IkonaIcon` extracted by ID and size.
    pub fn extract_subicons_by_ids(&self, icons: HashMap<String,i32>) -> Result<Vec<IkonaIcon>, String> {
        let mut ret_icons = Vec::<IkonaIcon>::with_capacity(icons.len());
        for (id, size) in icons {
            match self.handle.has_element_with_id(&id) {
                Ok(_) => {
                    let renderer = librsvg::CairoRenderer::new(&self.handle);

                    let filepath = format!("/tmp/ikona-{}.svg", rand::thread_rng()
                        .sample_iter(&Alphanumeric)
                        .take(40)
                        .collect::<String>());

                    let mut svg_surface = cairo::SvgSurface::new(f64::from(size), f64::from(size), filepath.clone());
                    svg_surface.set_document_unit(cairo::SvgUnit::Px);

                    let cairo_context = cairo::Context::new(&svg_surface);

                    match renderer.render_element(&cairo_context, Some(&id), &cairo::Rectangle{ x: 0.0,  y: 0.0, width: f64::from(size), height: f64::from(size) }) {
                        Err(_) => return Err("Failed to render subicon".to_string()),
                        Ok(_) => {
                            svg_surface.finish();

                            match IkonaIcon::new_from_path(filepath) {
                                Ok(value) => ret_icons.push(value),
                                Err(err) => return Err(err),
                            }
                        }
                    }
                },
                Err(_) => return Err("Badly formatted ID, or SVG does not have ID".to_string()),
            }
        }
        Ok(ret_icons)
    }
    /// Reads the contents of the `IkonaIcon` into a `String`.
    /// 
    /// # Example:
    /// ```
    /// use ikona::icons::IkonaIcon;
    /// 
    /// let icon = IkonaIcon::new_from_string("<svg></svg>").unwrap();
    /// 
    /// let string = icon.read_to_string().unwrap();
    /// ````
    pub fn read_to_string(&self) -> Result<String, String> {
        match fs::read_to_string(&self.filepath) {
            Ok(val) => Ok(val.to_string()),
            Err(_) => Err("Failed to read file".to_string()),
        }
    }
    /// Returns an `IkonaIcon` with a dark colour palette.
    pub fn convert_to_dark_from_light(&self) -> Result<IkonaIcon, String> {
        let icon_str = self.read_to_string()?;

        let mut icon_str_mut = icon_str.to_owned();

        if !icon_str_mut.contains("#31363b") {
            icon_str_mut = icon_str_mut.replace("#eff0f1", "#31363b");
            icon_str_mut = icon_str_mut.replace("#232629", "#eff0f1");
            icon_str_mut = icon_str_mut.replace("#fcfcfc", "#232629");
        }

        return IkonaIcon::new_from_string(icon_str_mut);
    }
    /// Returns an `IkonaIcon` with a light colour palette.
    pub fn convert_to_light_from_dark(&self) -> Result<IkonaIcon, String> {
        let icon_str = self.read_to_string()?;

        let mut icon_str_mut = icon_str.to_owned();

        if !icon_str_mut.contains("#fcfcfc") {
            icon_str_mut = icon_str_mut.replace("#232629", "#fcfcfc");
            icon_str_mut = icon_str_mut.replace("#eff0f1", "#232629");
            icon_str_mut = icon_str_mut.replace("#31363b", "#eff0f1");
        }

        return IkonaIcon::new_from_string(icon_str_mut);
    }
    /// Injects CSS and replaces hardcoded colours according to a dark
    /// colour palette.
    pub fn class_as_dark(&self) -> Result<IkonaIcon, String> {
        let icon_str = match self.read_to_string() {
            Ok(val) => val,
            Err(err) => return Err(err),
        };

        let mut icon_str_mut = icon_str.to_owned();

        let mut end_index = 0;
        let mut mode = 0;

        for (index, chr) in icon_str.chars().enumerate() {
            if chr == '<' {
                mode = 1;
                continue;
            }
            if mode == 1 && chr == 's' {
                mode = 2;
                continue;
            }
            if mode == 2 && chr == 'v' {
                mode = 3;
                continue;
            }
            if mode == 3 && chr == 'g' {
                mode = 4;
                continue;
            }
            if mode == 4 && chr == '>' {
                end_index = index+1;
                break;
            }
        }

        if end_index == 0 {
            return Err("Failed to find a <svg>".to_string())
        }

        let mut stylesheet = "".to_string();

        stylesheet_replace!(icon_str_mut, stylesheet, "#eff0f1", "Text");
        stylesheet_replace!(icon_str_mut, stylesheet, "#31363b", "Background");
        stylesheet_replace!(icon_str_mut, stylesheet, "#232629", "ViewBackground");
        stylesheet_replace!(icon_str_mut, stylesheet, "#3daee9", "ButtonFocus");
        stylesheet_replace!(icon_str_mut, stylesheet, "#27ae60", "PositiveText");
        stylesheet_replace!(icon_str_mut, stylesheet, "#f67400", "NeutralText");
        stylesheet_replace!(icon_str_mut, stylesheet, "#da4453", "NegativeText");

        if stylesheet != "" {
            icon_str_mut.insert_str(end_index, &format!(r#"<style type="text/css" id="current-color-scheme">{}</style>"#, stylesheet));
        }

        match IkonaIcon::new_from_string(icon_str_mut) {
            Ok(icon) => Ok(icon),
            Err(err) => Err(err),
        }
    }
    /// Injects CSS and replaces hardcoded colours according to a light
    /// colour palette.
    pub fn class_as_light(&self) -> Result<IkonaIcon, String> {
        let icon_str = match self.read_to_string() {
            Ok(val) => val,
            Err(err) => return Err(err),
        };

        let mut icon_str_mut = icon_str.to_owned();

        let mut end_index = 0;
        let mut mode = 0;

        for (index, chr) in icon_str.chars().enumerate() {
            if chr == '<' {
                mode = 1;
                continue;
            }
            if mode == 1 && chr == 's' {
                mode = 2;
                continue;
            }
            if mode == 2 && chr == 'v' {
                mode = 3;
                continue;
            }
            if mode == 3 && chr == 'g' {
                mode = 4;
                continue;
            }
            if mode == 4 && chr == '>' {
                end_index = index+1;
                break;
            }
        }

        if end_index == 0 {
            return Err("Failed to find a <svg>".to_string())
        }

        let mut stylesheet = "".to_string();

        stylesheet_replace!(icon_str_mut, stylesheet, "#232629", "Text");
        stylesheet_replace!(icon_str_mut, stylesheet, "#eff0f1", "Background");
        stylesheet_replace!(icon_str_mut, stylesheet, "#fcfcfc", "ViewBackground");
        stylesheet_replace!(icon_str_mut, stylesheet, "#3daee9", "ButtonFocus");
        stylesheet_replace!(icon_str_mut, stylesheet, "#27ae60", "PositiveText");
        stylesheet_replace!(icon_str_mut, stylesheet, "#f67400", "NeutralText");
        stylesheet_replace!(icon_str_mut, stylesheet, "#da4453", "NegativeText");

        if stylesheet != "" {
            icon_str_mut.insert_str(end_index, &format!(r#"<style type="text/css" id="current-color-scheme">{}</style>"#, stylesheet));
        }

        match IkonaIcon::new_from_string(icon_str_mut) {
            Ok(icon) => Ok(icon),
            Err(err) => Err(err),
        }
    }
}

mod tests;
