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

extern crate ikona;

use std::ffi::CStr;
use std::ffi::CString;
use std::os::raw::c_char;
use std::collections::HashMap;
use std::ptr;

use ikona::icons::IkonaIcon;

/*
 *
 * Constructors
 *
 */

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_new_from_path(in_path: *const c_char) -> *mut IkonaIcon {
    assert!(!in_path.is_null());

    let in_path_string = CStr::from_ptr(in_path).to_str().unwrap();

    let icon = match IkonaIcon::new_from_path(in_path_string.to_string()) {
        Ok(icon) => icon,
        Err(_) => return std::ptr::null_mut::<IkonaIcon>()
    };

    let boxed: Box::<IkonaIcon> = Box::new(icon);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_new_from_string(in_string: *const c_char) -> *mut IkonaIcon {
    assert!(!in_string.is_null());

    let in_path_string = CStr::from_ptr(in_string).to_str().unwrap();

    let icon = match IkonaIcon::new_from_string(in_path_string.to_string()) {
        Ok(icon) => icon,
        Err(_) => return std::ptr::null_mut::<IkonaIcon>()
    };

    let boxed: Box::<IkonaIcon> = Box::new(icon);

    Box::into_raw(boxed)
}

/*
 *
 * Properties
 *
 */

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_get_filepath(ptr: *mut IkonaIcon) -> *const c_char {
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
            Err(_) => return ptr::null_mut::<IkonaIcon>()
        };

        let $boxy: Box::<IkonaIcon> = Box::new(proc);
    };
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_optimize_with_rsvg(ptr: *mut IkonaIcon) -> *mut IkonaIcon {
    icon_operation!(ptr, optimize_with_rsvg, boxed);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_optimize_with_scour(ptr: *mut IkonaIcon) -> *mut IkonaIcon {
    icon_operation!(ptr, optimize_with_scour, boxed);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_optimize_all(ptr: *mut IkonaIcon) -> *mut IkonaIcon {
    icon_operation!(ptr, optimize_all, boxed);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_class_as_dark(ptr: *mut IkonaIcon) -> *mut IkonaIcon {
    icon_operation!(ptr, class_as_dark, boxed);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_class_as_light(ptr: *mut IkonaIcon) -> *mut IkonaIcon {
    icon_operation!(ptr, class_as_light, boxed);

    Box::into_raw(boxed)
}

/*
 *
 * Other
 *
 */

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_read_to_string(ptr: *mut IkonaIcon) -> *const c_char {
    assert!(!ptr.is_null());

    let icon = &*ptr;

    let proc = match icon.read_to_string() {
        Ok(icon) => icon,
        Err(_) => return CString::new("").expect("Failed to create CString").into_raw()
    };

    return CString::new(proc).expect("Failed to create CString").into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_extract_subicon_by_id(ptr: *mut IkonaIcon, id: *const c_char, target_size: i32) -> *mut IkonaIcon {
    assert!(!ptr.is_null());
    assert!(!id.is_null());
    
    let id_string = CStr::from_ptr(id).to_str().unwrap();

    let icon = &*ptr;

    let proc = match icon.extract_subicon_by_id(id_string, target_size) {
        Ok(icon) => icon,
        Err(_) => return ptr::null_mut::<IkonaIcon>()
    };

    let boxed: Box::<IkonaIcon> = Box::new(proc);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_extract_subicons_by_id(ptr: *mut IkonaIcon, ids: *const *const c_char, sizes: *const i32, sizes_length: i32) -> *mut *mut IkonaIcon {
    assert!(!ptr.is_null());
    
    let mut ids_len = 0;
    let mut array_ids = ids;
    while !(*array_ids).is_null() {
        array_ids = array_ids.offset(1);
        ids_len += 1;
    }

    let ids_slice = std::slice::from_raw_parts(ids, ids_len);
    let sizes_slice = std::slice::from_raw_parts(sizes, sizes_length as usize);
    let ids_slice_string: Vec<String> = ids_slice.iter()
                                        .map(|&s_ptr| {
                                            CStr::from_ptr(s_ptr)
                                                .to_str()
                                                .expect("Strings not UTF8")
                                                .to_owned()
                                                .to_string()
                                        })
                                        .collect();

    assert_eq!(ids_slice.len(), sizes_slice.len());

    let hash = ids_slice_string.iter().zip(sizes_slice.iter()).collect::<HashMap<&String, &i32>>();

    let icon = &*ptr;

    // TODO: convert hash of pointers to hash of values
    match icon.extract_subicons_by_ids(hash) {
        Ok(vals) => {
            // TODO: finish converting vector of icons to C array
        },
        Err(_) => {
            return ptr::null_mut::<ptr::null_mut<IkonaIcon>>();
        }
    }
}