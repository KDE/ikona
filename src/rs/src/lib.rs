
use std::ffi::CString;
use std::ffi::CStr;

use std::fs;

use std::os::raw::c_char;

extern crate rand;

use rand::Rng; 
use rand::distributions::Alphanumeric;

use librsvg;
use cairo;

#[no_mangle]
pub extern "C" fn ikona_extract_id_from_svg(in_path: *const c_char, id: *const c_char, target_size: i32) -> *const c_char {
    let in_path_string = unsafe { CStr::from_ptr(in_path).to_str().unwrap() };
    let id_string = unsafe { CStr::from_ptr(id).to_str().unwrap() };

    let svg_handle = match librsvg::Loader::new().read_path(in_path_string) {
        Ok(handle) => handle,
        Err(_e) => {
            return CString::new("Failed to load SVG").expect("Could not create CString").into_raw()
        }
    };

    match svg_handle.has_element_with_id(id_string) {
        Ok(val) => if !val {println!("Doesn't have element with ID {}", id_string); return CString::new("").expect("Could not create CString").into_raw()},
        Err(err) => {
            println!("[!] Failed to find element with ID {} in {}: {:?}", id_string, in_path_string, err);
            return CString::new("").expect("Could not create CString").into_raw();
        }
    };

    let renderer = librsvg::CairoRenderer::new(&svg_handle);

    let filepath = format!("/tmp/ikona-{}.svg", rand::thread_rng()
                           .sample_iter(&Alphanumeric)
                           .take(10)
                           .collect::<String>());

    let mut svg_surface = cairo::SvgSurface::new(f64::from(target_size), f64::from(target_size), filepath.clone());
    svg_surface.set_document_unit(cairo::SvgUnit::Px);

    let cr = cairo::Context::new(&svg_surface);

    match renderer.render_element(&cr, Some(id_string), &cairo::Rectangle{ x: 0.0,  y: 0.0, width: f64::from(target_size), height: f64::from(target_size) }) {
        Err(err) => {
            println!("[!] Failed to render document:\n\t {:?}", err);
            return CString::new("").expect("Could not create CString").into_raw();
        }
        Ok(_) => (),
    };

    svg_surface.finish();
    
    let svg = match fs::read_to_string(filepath.clone()) {
        Ok(val) => val,
        Err(_) => return CString::new("").expect("Could not create CString").into_raw(),
    };

    let svg_cstring = CString::new(svg).expect("Could not create CString");

    return svg_cstring.into_raw();
}
