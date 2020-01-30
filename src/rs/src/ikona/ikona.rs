pub mod Ikona {
    extern crate rand;
    use rand::Rng; 
    use rand::distributions::Alphanumeric;

    use librsvg;
    use cairo;

    use std::fs;

    pub struct Icon {
        handle: librsvg::SvgHandle,
        filepath: &'static str,
    }
    
    impl Icon {
        pub fn new_from_path(in_path: &'static str) -> Result<Icon, &'static str> {
            match librsvg::Loader::new().read_path(in_path) {
                Ok(handle) => Ok(Icon{handle: handle, filepath: in_path}),
                Err(_) => Err("There was an error loading the SVG"),
            }
        }
        pub fn extract_subicon_by_id(&self, id: &str, target_size: i32) -> Result<Icon, &'static str> {
            match self.handle.has_element_with_id(id) {
                Ok(_) => {
                    let renderer = librsvg::CairoRenderer::new(&self.handle);
    
                    let filepath = format!("/tmp/ikona-{}.svg", rand::thread_rng()
                        .sample_iter(&Alphanumeric)
                        .take(10)
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
    }
}