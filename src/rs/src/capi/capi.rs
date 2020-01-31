extern crate ikona;

use std::ffi::CStr;
use std::ffi::CString;
use std::os::raw::c_char;

use ikona::Ikona;

#[no_mangle]
pub extern "C" fn ikona_extract_id_from_svg(in_path: *const c_char, id: *const c_char, target_size: i32) -> *const c_char {
    let in_path_string = unsafe { CStr::from_ptr(in_path).to_str().unwrap() };
    let id_string = unsafe { CStr::from_ptr(id).to_str().unwrap() };

    let icon = match Ikona::Icon::new_from_path(in_path_string.to_string()) {
        Ok(val) => val,
        Err(_) => return CString::new("").expect("Failed to create CString").into_raw(),
    };
    let sub_icon = match icon.extract_subicon_by_id(id_string, target_size) {
        Ok(val) => val,
        Err(_) => return CString::new("").expect("Failed to create CString").into_raw(),
    };

    match sub_icon.read_to_string() {
        Ok(val) => CString::new(val).expect("Failed to create CString").into_raw(),
        Err(_) => CString::new("").expect("Failed to create CString").into_raw(),
    }
}
