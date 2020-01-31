pub mod Ikona {
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

    use regex::Regex;

    pub struct Icon {
        handle: librsvg::SvgHandle,
        filepath: &'static str,
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
    impl Icon {
        pub fn new_from_path(in_path: &'static str) -> Result<Icon, &'static str> {
            match librsvg::Loader::new().read_path(in_path) {
                Ok(handle) => Ok(Icon{handle: handle, filepath: in_path}),
                Err(_) => Err("There was an error loading the SVG"),
            }
        }
        pub fn new_from_string(string: &'static str) -> Result<Icon, &'static str> {
            let filepath = format!("/tmp/ikona-{}.svg", rand::thread_rng()
                .sample_iter(&Alphanumeric)
                .take(40)
                .collect::<String>());

            match fs::write(filepath.clone(), string) {
                Ok(_) => {
                    match librsvg::Loader::new().read_path(filepath.clone()) {
                        Ok(handle) => Ok(Icon{handle: handle, filepath: Box::leak(filepath.into_boxed_str())}),
                        Err(_) => Err("There was an error loading the SVG")
                    }
                },
                Err(_) => Err("There was an error creating an internal file")
            }
        }
        pub fn get_filepath(&self) -> &'static str {
            self.filepath
        }
        pub fn optimize_with_rsvg(&self) -> Result<Icon, &'static str> {
            let renderer = librsvg::CairoRenderer::new(&self.handle);

            let filepath = format!("/tmp/ikona-{}.svg", rand::thread_rng()
                            .sample_iter(&Alphanumeric)
                            .take(40)
                            .collect::<String>());

            let width = f64::from(
                match renderer.intrinsic_dimensions().width {
                    Some(val) => val.length,
                    None => return Err("Failed to get width")
                }
            );

            let height = f64::from(
                match renderer.intrinsic_dimensions().height {
                    Some(val) => val.length,
                    None => return Err("Failed to get height")
                }
            );

            let svg_surface = cairo::SvgSurface::new(width, height, filepath.clone());
            
            let cairo_context = cairo::Context::new(&svg_surface);

            match renderer.render_document(&cairo_context, &cairo::Rectangle{x:0.0,y:0.0,width:width,height:height}) {
                Err(_) => Err("Failed to render SVG"),
                Ok(_) => {
                    svg_surface.finish();
    
                    return Icon::new_from_path(Box::leak(filepath.into_boxed_str()));
                }
            }
        }
        pub fn optimize_with_scour(&self) -> Result<Icon, &'static str> {
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
                                       .arg(self.filepath)
                                       .output() {
                Ok(res) => res,
                Err(_) => return Err("Failed to get scour output"),
            };
            if output.status.code().unwrap() != 0 {
                return Err("Scour failed to parse icon");
            }
            
            let string = String::from_utf8_lossy(&output.stdout).into_owned();

            return Icon::new_from_string(Box::leak(string.into_boxed_str()));
        }
        pub fn optimize_all(&self) -> Result<Icon, &'static str> {
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
        pub fn extract_subicon_by_id(&self, id: &str, target_size: i32) -> Result<Icon, &'static str> {
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
                        Err(_) => Err("Failed to render sub icon"),
                        Ok(_) => {
                            svg_surface.finish();
    
                            return Icon::new_from_path(Box::leak(filepath.into_boxed_str()));
                        },
                    }
                },
                Err(_) => Err("Badly formatted ID, or SVG does not have ID"),
            }
        }
        pub fn read_to_string(&self) -> Result<String, &'static str> {
            match fs::read_to_string(&self.filepath) {
                Ok(val) => Ok(val.to_string()),
                Err(_) => Err("Failed to read file"),
            }
        }
        pub fn class_as_dark(&self) -> Result<Icon, &'static str> {
            let icon_str = match self.read_to_string() {
                Ok(val) => val,
                Err(err) => return Err(err),
            };

            let mut icon_str_mut = icon_str.to_owned();

            let re = Regex::new("<svg.*>").unwrap();

            let style = match re.find(&icon_str) {
                Some(val) => val,
                None => return Err("Failed to find a <svg>"),
            };

            let mut stylesheet = "".to_string();

            stylesheet_replace!(icon_str_mut, stylesheet, "#eff0f1", "Text");
            stylesheet_replace!(icon_str_mut, stylesheet, "#31363b", "Background");
            stylesheet_replace!(icon_str_mut, stylesheet, "#232629", "ViewBackground");
            stylesheet_replace!(icon_str_mut, stylesheet, "#3daee9", "ButtonFocus");
            stylesheet_replace!(icon_str_mut, stylesheet, "#27ae60", "PositiveText");
            stylesheet_replace!(icon_str_mut, stylesheet, "#f67400", "NeutralText");
            stylesheet_replace!(icon_str_mut, stylesheet, "#da4453", "NegativeText");

            icon_str_mut.insert_str(style.end(), &format!(r#"<style type="text/css" id="current-color-scheme">{}</style>"#, stylesheet));

            match Icon::new_from_string(Box::leak(icon_str_mut.into_boxed_str())) {
                Ok(icon) => Ok(icon),
                Err(err) => Err(err),
            }
        }
        pub fn class_as_light(&self) -> Result<Icon, &'static str> {
            let icon_str = match self.read_to_string() {
                Ok(val) => val,
                Err(err) => return Err(err),
            };

            let mut icon_str_mut = icon_str.to_owned();

            let re = Regex::new("<svg.*>").unwrap();

            let style = match re.find(&icon_str) {
                Some(val) => val,
                None => return Err("Failed to find a <svg>"),
            };

            let mut stylesheet = "".to_string();

            stylesheet_replace!(icon_str_mut, stylesheet, "#232629", "Text");
            stylesheet_replace!(icon_str_mut, stylesheet, "#eff0f1", "Background");
            stylesheet_replace!(icon_str_mut, stylesheet, "#fcfcfc", "ViewBackground");
            stylesheet_replace!(icon_str_mut, stylesheet, "#3daee9", "ButtonFocus");
            stylesheet_replace!(icon_str_mut, stylesheet, "#27ae60", "PositiveText");
            stylesheet_replace!(icon_str_mut, stylesheet, "#f67400", "NeutralText");
            stylesheet_replace!(icon_str_mut, stylesheet, "#da4453", "NegativeText");

            icon_str_mut.insert_str(style.end(), &format!(r#"<style type="text/css" id="current-color-scheme">{}</style>"#, stylesheet));

            match Icon::new_from_string(Box::leak(icon_str_mut.into_boxed_str())) {
                Ok(icon) => Ok(icon),
                Err(err) => Err(err),
            }
        }
    }

    #[test]
    fn test_stylesheet_injection() {
        let data = r###"
<svg>
    <g fill="#eff0f1">
    </g>
</svg>
        "###;

        let data_expected = r###"
<svg><style type="text/css" id="current-color-scheme">.ColorScheme-Text { color: #eff0f1; }</style>
    <g fill="currentColor" class="ColorScheme-Text">
    </g>
</svg>
        "###;

        let icon = Icon::new_from_string(data).unwrap();

        let dark = icon.class_as_dark().unwrap();

        let dark_str = dark.read_to_string().unwrap();

        println!("Data: {}", dark_str);
        println!("Expected Data: {}", data_expected);
        assert_eq!(dark_str, data_expected);
    }
}
