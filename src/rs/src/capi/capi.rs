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

#![allow(clippy::missing_safety_doc)]

extern crate ikona;

use std::convert::TryInto;
use std::ffi::CStr;
use std::ffi::CString;
use std::os::raw::c_char;
use std::ptr;

use ikona::icons::breeze::BreezeIcon;
use ikona::icons::Icon;

use ikona::icontheme::*;

/*
 *
 * Constructors
 *
 */

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_new_from_path(in_path: *const c_char) -> *mut Icon {
    assert!(!in_path.is_null());

    let in_path_string = CStr::from_ptr(in_path).to_str().unwrap();

    let icon = match Icon::new_from_path(in_path_string.to_string()) {
        Ok(icon) => icon,
        Err(err) => {
            println!("{}", err);
            return std::ptr::null_mut::<Icon>();
        }
    };

    let boxed: Box<Icon> = Box::new(icon);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_new_from_string(in_string: *const c_char) -> *mut Icon {
    assert!(!in_string.is_null());

    let in_path_string = CStr::from_ptr(in_string).to_str().unwrap();

    let icon = match Icon::new_from_string(in_path_string.to_string()) {
        Ok(icon) => icon,
        Err(err) => {
            println!("{}", err);
            return std::ptr::null_mut::<Icon>();
        }
    };

    let boxed: Box<Icon> = Box::new(icon);

    Box::into_raw(boxed)
}

/*
 *
 * Properties
 *
 */

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_get_filepath(ptr: *mut Icon) -> *const c_char {
    assert!(!ptr.is_null());

    let icon = &*ptr;

    CString::new(icon.get_filepath())
        .expect("Failed to create CString")
        .into_raw()
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
            Err(_) => return ptr::null_mut::<Icon>(),
        };

        let $boxy: Box<Icon> = Box::new(proc);
    };
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_optimize_with_rsvg(ptr: *mut Icon) -> *mut Icon {
    icon_operation!(ptr, optimize_with_rsvg, boxed);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_optimize_with_scour(ptr: *mut Icon) -> *mut Icon {
    icon_operation!(ptr, optimize_with_scour, boxed);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_optimize_all(ptr: *mut Icon) -> *mut Icon {
    icon_operation!(ptr, optimize_all, boxed);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_class_as_dark(ptr: *mut Icon) -> *mut Icon {
    icon_operation!(ptr, class_as_dark, boxed);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_class_as_light(ptr: *mut Icon) -> *mut Icon {
    icon_operation!(ptr, class_as_light, boxed);

    Box::into_raw(boxed)
}

/*
 *
 * Other
 *
 */

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_read_to_string(ptr: *mut Icon) -> *const c_char {
    assert!(!ptr.is_null());

    let icon = &*ptr;

    let proc = match icon.read_to_string() {
        Ok(icon) => icon,
        Err(_) => {
            return CString::new("")
                .expect("Failed to create CString")
                .into_raw()
        }
    };

    CString::new(proc)
        .expect("Failed to create CString")
        .into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_extract_subicon_by_id(
    ptr: *mut Icon,
    id: *const c_char,
    target_size: i32,
) -> *mut Icon {
    assert!(!ptr.is_null());
    assert!(!id.is_null());

    let id_string = CStr::from_ptr(id).to_str().unwrap();

    let icon = &*ptr;

    let proc = match icon.extract_subicon_by_id(id_string, target_size) {
        Ok(icon) => icon,
        Err(_) => return ptr::null_mut::<Icon>(),
    };

    let boxed: Box<Icon> = Box::new(proc);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_free(ptr: *mut Icon) {
    assert!(!ptr.is_null());

    Box::from_raw(ptr);
}

/*
 *
 *  Icon Themes
 *
 */

#[repr(C)]
pub struct IconThemeList {
    pub theme_vec: Vec<IconTheme>
}

#[repr(C)]
pub struct IconDirectoryList {
    pub vec: *const Vec<IconDirectory>
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_list_new() -> *mut IconThemeList {
    let mut list = match IconTheme::icon_themes() {
        Ok(res) => {
            let mut icon_theme_list = IconThemeList {
                theme_vec: res,
            };
            Box::new(icon_theme_list)
        },
        Err(err) => return ptr::null_mut::<IconThemeList>()
    };

    Box::into_raw(list)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_list_free(ptr: *mut IconThemeList) {
    assert!(!ptr.is_null());

    Box::from_raw(ptr);
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_list_get_length(ptr: *mut IconThemeList) -> u16 {
    assert!(!ptr.is_null());

    let theme = &*ptr;

    theme.theme_vec.len().try_into().unwrap()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_list_get_index(ptr: *mut IconThemeList, index: u16) -> *const IconTheme {
    assert!(!ptr.is_null());

    let theme = &*ptr;

    let mut pointer: *const IconTheme = &theme.theme_vec[usize::from(index)];

    pointer
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_get_name(ptr: *const IconTheme) -> *const c_char {
    assert!(!ptr.is_null());

    let theme = &*ptr;

    CString::new(theme.name.clone()).expect("Failed to create CString").into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_get_display_name(ptr: *const IconTheme) -> *const c_char {
    assert!(!ptr.is_null());

    let theme = &*ptr;

    CString::new(theme.display_name.clone()).expect("Failed to create CString").into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_get_directory_list(ptr: *const IconTheme) -> *mut IconDirectoryList {
    assert!(!ptr.is_null());

    let theme = &*ptr;

    Box::into_raw({
        Box::new({
            IconDirectoryList {
                vec: {
                    let ptr: *const Vec<IconDirectory> = &theme.directories;
                    ptr
                }
            }
        })
    })
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_list_free(ptr: *mut IconDirectoryList) {
    assert!(!ptr.is_null());

    Box::from_raw(ptr);
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_list_get_length(ptr: *mut IconDirectoryList) -> u16 {
    assert!(!ptr.is_null());

    let directory = &*ptr;
    let vec = &*directory.vec;

    vec.len().try_into().unwrap()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_list_get_index(ptr: *mut IconDirectoryList, index: u16) -> *const IconDirectory {
    assert!(!ptr.is_null());

    let directory = &*ptr;
    let vec = &*directory.vec;

    let mut pointer: *const IconDirectory = &vec[usize::from(index)];

    pointer
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_get_size(ptr: *const IconDirectory) -> i32 {
    assert!(!ptr.is_null());

    let directory = &*ptr;

    directory.size
}