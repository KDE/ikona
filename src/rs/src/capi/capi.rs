extern crate ikona;

use std::ffi::CStr;
use std::ffi::CString;
use std::os::raw::c_char;
use std::ptr;

use ikona::Ikona;

/*
 *
 * Constructors
 *
 */

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_new_from_path(in_path: *const c_char) -> *mut Ikona::IkonaIcon {
    assert!(!in_path.is_null());

    let in_path_string = CStr::from_ptr(in_path).to_str().unwrap();

    let icon = match Ikona::IkonaIcon::new_from_path(in_path_string.to_string()) {
        Ok(icon) => icon,
        Err(_) => return std::ptr::null_mut::<Ikona::IkonaIcon>()
    };

    let boxed: Box::<Ikona::IkonaIcon> = Box::new(icon);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_new_from_string(in_string: *const c_char) -> *mut Ikona::IkonaIcon {
    assert!(!in_string.is_null());

    let in_path_string = CStr::from_ptr(in_string).to_str().unwrap();

    let icon = match Ikona::IkonaIcon::new_from_string(in_path_string.to_string()) {
        Ok(icon) => icon,
        Err(_) => return std::ptr::null_mut::<Ikona::IkonaIcon>()
    };

    let boxed: Box::<Ikona::IkonaIcon> = Box::new(icon);

    Box::into_raw(boxed)
}

/*
 *
 * Properties
 *
 */

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_get_filepath(ptr: *mut Ikona::IkonaIcon) -> *const c_char {
    assert!(!ptr.is_null());

    let icon = &*ptr;

    CString::new(icon.get_filepath()).expect("Failed to create CString").into_raw()
}

/*
 *
 * Operations
 *
 */

macro_rules! icon_operation {
    ($ptr:ident, $func:ident, $boxy:ident) => {
        assert!(!$ptr.is_null());

        let icon = &*$ptr;

        let proc = match icon.$func() {
            Ok(icon) => icon,
            Err(_) => return ptr::null_mut::<Ikona::IkonaIcon>()
        };

        let $boxy: Box::<Ikona::IkonaIcon> = Box::new(proc);
    };
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_optimize_with_rsvg(ptr: *mut Ikona::IkonaIcon) -> *mut Ikona::IkonaIcon {
    icon_operation!(ptr, optimize_with_rsvg, boxed);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_optimize_with_scour(ptr: *mut Ikona::IkonaIcon) -> *mut Ikona::IkonaIcon {
    icon_operation!(ptr, optimize_with_scour, boxed);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_optimize_all(ptr: *mut Ikona::IkonaIcon) -> *mut Ikona::IkonaIcon {
    icon_operation!(ptr, optimize_all, boxed);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_class_as_dark(ptr: *mut Ikona::IkonaIcon) -> *mut Ikona::IkonaIcon {
    icon_operation!(ptr, class_as_dark, boxed);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_class_as_light(ptr: *mut Ikona::IkonaIcon) -> *mut Ikona::IkonaIcon {
    icon_operation!(ptr, class_as_light, boxed);

    Box::into_raw(boxed)
}

/*
 *
 * Other
 *
 */

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_read_to_string(ptr: *mut Ikona::IkonaIcon) -> *const c_char {
    assert!(!ptr.is_null());

    let icon = &*ptr;

    let proc = match icon.read_to_string() {
        Ok(icon) => icon,
        Err(_) => return CString::new("").expect("Failed to create CString").into_raw()
    };

    return CString::new(proc).expect("Failed to create CString").into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_extract_subicon_by_id(ptr: *mut Ikona::IkonaIcon, id: *const c_char, target_size: i32) -> *mut Ikona::IkonaIcon {
    assert!(!ptr.is_null());
    assert!(!id.is_null());
    
    let id_string = CStr::from_ptr(id).to_str().unwrap();

    let icon = &*ptr;

    let proc = match icon.extract_subicon_by_id(id_string, target_size) {
        Ok(icon) => icon,
        Err(_) => return ptr::null_mut::<Ikona::IkonaIcon>()
    };

    let boxed: Box::<Ikona::IkonaIcon> = Box::new(proc);

    Box::into_raw(boxed)
}