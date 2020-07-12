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

use rand::distributions::Alphanumeric;
use rand::Rng;

use std::collections::HashMap;
use std::fs;
use std::process::Command;
use std::str;

#[cfg(feature = "with-svgcleaner")]
use svgcleaner;
#[cfg(feature = "with-svgcleaner")]
use svgdom;

/// Object that exposes Ikona's icon manipulation functionality.
///
/// This is the entrypoint for Ikona's functionality.
#[repr(C)]
pub struct Icon {
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
macro_rules! cairo_err {
    ($cairo: expr) => {
        match $cairo {
            Ok(surf) => surf,
            Err(err) => return Err(format!("{:?}", err)),
        }
    };
}
impl Icon {
    /// Creates an `Icon`, reading the contents from `in_path`.
    ///
    /// # Example:
    ///
    /// ```ignore
    /// use ikona::icons::Icon;
    ///
    /// let icon = Icon::new_from_path("example.svg".to_string()).unwrap();
    /// ```
    pub fn new_from_path(filepath: String) -> Result<Icon, String> {
        match librsvg::Loader::new().read_path(filepath.clone()) {
            Ok(handle) => Ok(Icon { handle, filepath }),
            Err(err) => Err(format!("There was an error loading the SVG: {:?}", err)),
        }
    }
    /// Creates an `Icon`, reading the contents from a String.
    ///
    /// # Example:
    ///
    /// ```
    /// use ikona::icons::Icon;
    ///
    /// let icon = Icon::new_from_string("<svg></svg>".to_string()).unwrap();
    /// ```
    pub fn new_from_string(string: String) -> Result<Icon, String> {
        let filepath = format!(
            "/tmp/ikona-{}.svg",
            rand::thread_rng()
                .sample_iter(&Alphanumeric)
                .take(40)
                .collect::<String>()
        );

        match fs::write(filepath.clone(), string) {
            Ok(_) => match librsvg::Loader::new().read_path(filepath.clone()) {
                Ok(handle) => Ok(Icon { handle, filepath }),
                Err(err) => Err(format!("There was an error loading the SVG: {:?}", err)),
            },
            Err(_) => Err("There was an error creating an internal file".to_string()),
        }
    }
    /// Reads the filepath of an `Icon` into a `String`.
    ///
    /// # Example:
    /// ```
    /// use ikona::icons::Icon;
    ///
    /// let icon = Icon::new_from_string("<svg></svg>".to_string()).unwrap();
    ///
    /// let filepath = icon.get_filepath();
    /// ````
    pub fn get_filepath(&self) -> String {
        self.filepath.clone()
    }
    /// Optimizes the SVG of the current `Icon` with rsvg and returns it
    /// as a new `Icon`.
    ///
    /// # Example:
    /// ```
    /// use ikona::icons::Icon;
    ///
    /// let icon = Icon::new_from_string("<svg></svg>".to_string()).unwrap();
    ///
    /// let optimized = icon.optimize_with_rsvg();
    /// ````
    pub fn optimize_with_rsvg(&self) -> Result<Icon, String> {
        let renderer = librsvg::CairoRenderer::new(&self.handle);

        let filepath = format!(
            "/tmp/ikona-{}.svg",
            rand::thread_rng()
                .sample_iter(&Alphanumeric)
                .take(40)
                .collect::<String>()
        );

        let width = match renderer.intrinsic_dimensions().width {
            Some(val) => val.length,
            None => match renderer.intrinsic_dimensions().vbox {
                Some(val) => val.width,
                None => return Err("Failed to get width".to_string()),
            },
        };

        let height = match renderer.intrinsic_dimensions().height {
            Some(val) => val.length,
            None => match renderer.intrinsic_dimensions().vbox {
                Some(val) => val.height,
                None => return Err("Failed to get height".to_string()),
            },
        };

        let svg_surface = cairo_err!(cairo::SvgSurface::new(
            width,
            height,
            Some(filepath.clone())
        ));

        let cairo_context = cairo::Context::new(&svg_surface);

        match renderer.render_document(
            &cairo_context,
            &cairo::Rectangle {
                x: 0.0,
                y: 0.0,
                width,
                height,
            },
        ) {
            Err(_) => Err("Failed to render SVG".to_string()),
            Ok(_) => {
                svg_surface.finish();

                Icon::new_from_path(filepath)
            }
        }
    }
    /// Optimizes the SVG of the current `Icon` with scour and returns it
    /// as a new `Icon`.
    ///
    /// # Example:
    /// ```
    /// use ikona::icons::Icon;
    ///
    /// let icon = Icon::new_from_string("<svg></svg>".to_string()).unwrap();
    ///
    /// let optimized = icon.optimize_with_scour();
    /// ````
    pub fn optimize_with_scour(&self) -> Result<Icon, String> {
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
            .output()
        {
            Ok(res) => res,
            Err(_) => return Err("Failed to get scour output".to_string()),
        };
        if output.status.code().unwrap() != 0 {
            return Err("Scour failed to parse icon".to_string());
        }

        let string = String::from_utf8_lossy(&output.stdout).into_owned();

        Icon::new_from_string(string)
    }
    #[cfg(feature = "with-svgcleaner")]
    pub fn optimize_with_svgcleaner(&self) -> Result<Icon, String> {
        let icon_string = self.read_to_string()?;

        let mut doc = match svgdom::Document::from_str(&icon_string) {
            Ok(doc) => doc,
            Err(err) => return Err(format!("{:?}", err)),
        };

        match svgcleaner::cleaner::clean_doc(
            &mut doc,
            &svgcleaner::CleaningOptions::default(),
            &svgcleaner::WriteOptions::default(),
        ) {
            Ok(()) => (),
            Err(err) => return Err(format!("{:?}", err)),
        };

        use svgdom::ToStringWithOptions;

        Icon::new_from_string(doc.to_string_with_opt(&svgdom::WriteOptions::default()))
    }
    /// Optimizes the SVG of the current `Icon` with all methods
    /// and returns it as a new `Icon`.
    ///
    /// # Example:
    /// ```
    /// use ikona::icons::Icon;
    ///
    /// let icon = Icon::new_from_string("<svg></svg>".to_string()).unwrap();
    ///
    /// let optimized = icon.optimize_all();
    /// ````
    #[cfg(feature = "with-svgcleaner")]
    pub fn optimize_all(&self) -> Result<Icon, String> {
        match self.optimize_with_rsvg() {
            Ok(ok) => match ok.optimize_with_svgcleaner() {
                Ok(ok) => Ok(ok),
                Err(err) => Err(err),
            },
            Err(err) => Err(err),
        }
    }
    /// Optimizes the SVG of the current `Icon` with all methods
    /// and returns it as a new `Icon`.
    ///
    /// # Example:
    /// ```
    /// use ikona::icons::Icon;
    ///
    /// let icon = Icon::new_from_string("<svg></svg>".to_string()).unwrap();
    ///
    /// let optimized = icon.optimize_all();
    /// ````
    #[cfg(not(feature = "with-svgcleaner"))]
    pub fn optimize_all(&self) -> Result<Icon, String> {
        match self.optimize_with_rsvg() {
            Ok(ok) => match ok.optimize_with_scour() {
                Ok(ok) => Ok(ok),
                Err(err) => Err(err),
            },
            Err(err) => Err(err),
        }
    }
    /// Returns an child `Icon` extracted by ID and size.
    pub fn extract_subicon_by_id(&self, id: &str, target_size: i32) -> Result<Icon, String> {
        match self.handle.has_element_with_id(id) {
            Ok(_) => {
                let renderer = librsvg::CairoRenderer::new(&self.handle);

                let filepath = format!(
                    "/tmp/ikona-{}.svg",
                    rand::thread_rng()
                        .sample_iter(&Alphanumeric)
                        .take(40)
                        .collect::<String>()
                );

                let mut svg_surface = cairo_err!(cairo::SvgSurface::new(
                    f64::from(target_size),
                    f64::from(target_size),
                    Some(filepath.clone())
                ));
                svg_surface.set_document_unit(cairo::SvgUnit::Px);

                let cairo_context = cairo::Context::new(&svg_surface);

                match renderer.render_element(
                    &cairo_context,
                    Some(id),
                    &cairo::Rectangle {
                        x: 0.0,
                        y: 0.0,
                        width: f64::from(target_size),
                        height: f64::from(target_size),
                    },
                ) {
                    Err(_) => Err("Failed to render sub icon".to_string()),
                    Ok(_) => {
                        svg_surface.finish();

                        Icon::new_from_path(filepath)
                    }
                }
            }
            Err(_) => Err("Badly formatted ID, or SVG does not have ID".to_string()),
        }
    }
    /// Returns children `Icon`s extracted by ID and size.
    pub fn extract_subicons_by_ids(
        &self,
        icons: HashMap<String, i32>,
    ) -> Result<Vec<Icon>, String> {
        let mut ret_icons = Vec::<Icon>::with_capacity(icons.len());
        for (id, size) in icons {
            let subicon = self.extract_subicon_by_id(&id, size)?;
            ret_icons.push(subicon);
        }
        Ok(ret_icons)
    }
    /// Crops to a subicon.
    pub fn crop_to_subicon(&self, id: &str, target_size: i32) -> Result<Icon, String> {
        match self.handle.has_element_with_id(id) {
            Ok(_) => {
                let renderer = librsvg::CairoRenderer::new(&self.handle);
                let height = match renderer.intrinsic_dimensions().height {
                    Some(val) => val.length,
                    None => return Err("Failed to grab height".to_string()),
                };
                let width = match renderer.intrinsic_dimensions().width {
                    Some(val) => val.length,
                    None => return Err("Failed to grab width".to_string()),
                };
                let viewport = cairo::Rectangle {
                    x: 0.0,
                    y: 0.0,
                    height,
                    width,
                };

                let (_, log) = match renderer.geometry_for_layer(Some(id), &viewport) {
                    Ok((ink, log)) => (ink, log),
                    Err(err) => return Err(format!("{:?}", err)),
                };

                let filepath = format!(
                    "/tmp/ikona-{}.svg",
                    rand::thread_rng()
                        .sample_iter(&Alphanumeric)
                        .take(40)
                        .collect::<String>()
                );

                let mut svg_surface = cairo_err!(cairo::SvgSurface::new(
                    f64::from(target_size),
                    f64::from(target_size),
                    Some(filepath.clone())
                ));
                svg_surface.set_document_unit(cairo::SvgUnit::Px);

                let cairo_context = cairo::Context::new(&svg_surface);
                cairo_context.scale(
                    f64::from(target_size) / log.width,
                    f64::from(target_size) / log.height,
                );
                cairo_context.translate(-log.x, -log.y);

                match renderer.render_document(&cairo_context, &viewport) {
                    Err(err) => Err(format!("{:?}", err)),
                    Ok(_) => {
                        svg_surface.finish();

                        Icon::new_from_path(filepath)
                    }
                }
            }
            Err(_) => Err("Badly formatted ID, or SVG does not have ID".to_string()),
        }
    }
    /// Returns a vector of cropped subicons.
    pub fn crop_to_subicons(&self, icons: HashMap<String, i32>) -> Result<Vec<Icon>, String> {
        let mut ret_icons = Vec::<Icon>::with_capacity(icons.len());
        for (id, size) in icons {
            let subicon = self.crop_to_subicon(&id, size)?;
            ret_icons.push(subicon);
        }
        Ok(ret_icons)
    }
    /// Returns the icon with added padding to all sides
    pub fn add_padding(&self, padding: i32) -> Result<Icon, String> {
        let renderer = librsvg::CairoRenderer::new(&self.handle);

        let height = match renderer.intrinsic_dimensions().height {
            Some(val) => val.length,
            None => return Err("Failed to grab height".to_string()),
        };
        let width = match renderer.intrinsic_dimensions().width {
            Some(val) => val.length,
            None => return Err("Failed to grab width".to_string()),
        };

        let viewport = cairo::Rectangle {
            x: 0.0,
            y: 0.0,
            height,
            width,
        };

        let filepath = format!(
            "/tmp/ikona-{}.svg",
            rand::thread_rng()
                .sample_iter(&Alphanumeric)
                .take(40)
                .collect::<String>()
        );

        let mut svg_surface = cairo_err!(cairo::SvgSurface::new(
            width + f64::from(padding * 2),
            height + f64::from(padding * 2),
            Some(filepath.clone())
        ));
        svg_surface.set_document_unit(cairo::SvgUnit::Px);

        let cairo_context = cairo::Context::new(&svg_surface);
        cairo_context.translate(f64::from(padding), f64::from(padding));

        match renderer.render_document(&cairo_context, &viewport) {
            Err(err) => Err(format!("{:?}", err)),
            Ok(_) => {
                svg_surface.finish();

                Icon::new_from_path(filepath)
            }
        }
    }
    ///
    /// Reads the contents of the `Icon` into a `String`.
    ///
    /// # Example:
    /// ```
    /// use ikona::icons::Icon;
    ///
    /// let icon = Icon::new_from_string("<svg></svg>".to_string()).unwrap();
    ///
    /// let string = icon.read_to_string();
    /// ````
    pub fn read_to_string(&self) -> Result<String, String> {
        match fs::read_to_string(&self.filepath) {
            Ok(val) => Ok(val),
            Err(_) => Err("Failed to read file".to_string()),
        }
    }
    /// Returns an `Icon` with stylesheet injected into it.
    pub fn inject_stylesheet(
        &self,
        stylesheet: String,
        id: Option<String>,
    ) -> Result<Icon, String> {
        let mut icon_str_mut = self.read_to_string()?;

        let mut end_index = 0;
        let mut mode = 0;

        for (index, chr) in icon_str_mut.chars().enumerate() {
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
                end_index = index + 1;
                break;
            }
        }

        if end_index == 0 {
            return Err("Failed to find a <svg>".to_string());
        }

        match id {
            Some(val) => {
                icon_str_mut.insert_str(
                    end_index,
                    &format!(
                        r#"<style type="text/css" id="{}">{}</style>"#,
                        val, stylesheet
                    ),
                );
            }
            None => {
                icon_str_mut.insert_str(
                    end_index,
                    &format!(r#"<style type="text/css">{}</style>"#, stylesheet),
                );
            }
        }

        Icon::new_from_string(icon_str_mut)
    }
    /// Returns an `Icon` with colours replaced and stylesheeted.
    pub fn replace_colours_with_classes(
        &self,
        map: HashMap<String, String>,
        add_style: bool,
        id: Option<String>,
    ) -> Result<Icon, String> {
        let mut self_string = self.read_to_string()?;
        let mut stylesheet = "".to_string();

        let mut end_index = 0;
        let mut mode = 0;

        for (index, chr) in self_string.chars().enumerate() {
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
                end_index = index + 1;
                break;
            }
        }

        if end_index == 0 {
            return Err("Failed to find a <svg>".to_string());
        }

        for (key, val) in map.iter() {
            stylesheet_replace!(self_string, stylesheet, key, val);
        }

        if stylesheet != "" && add_style {
            match id {
                Some(val) => {
                    self_string.insert_str(
                        end_index,
                        &format!(
                            r#"<style type="text/css" id="{}">{}</style>"#,
                            val, stylesheet
                        ),
                    );
                }
                None => {
                    self_string.insert_str(
                        end_index,
                        &format!(r#"<style type="text/css">{}</style>"#, stylesheet),
                    );
                }
            }
        }

        Icon::new_from_string(self_string)
    }
}

pub mod breeze;
pub mod gnome;

#[cfg(test)]
mod tests;
