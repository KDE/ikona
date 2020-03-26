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
pub unsafe extern "C" fn ikona_icon_new_from_path(in_path: *mut c_char) -> *mut Icon {
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
pub unsafe extern "C" fn ikona_icon_new_from_string(in_string: *mut c_char) -> *mut Icon {
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
pub unsafe extern "C" fn ikona_icon_get_filepath(ptr: *mut Icon) -> *mut c_char {
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
pub unsafe extern "C" fn ikona_icon_read_to_string(ptr: *mut Icon) -> *mut c_char {
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
    id: *mut c_char,
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
pub unsafe extern "C" fn ikona_icon_crop_to_subicon(
    ptr: *mut Icon,
    id: *mut c_char,
    target_size: i32,
) -> *mut Icon {
    assert!(!ptr.is_null());
    assert!(!id.is_null());

    let id_string = CStr::from_ptr(id).to_str().unwrap();

    let icon = &*ptr;

    let proc = match icon.crop_to_subicon(id_string, target_size) {
        Ok(icon) => icon,
        Err(_) => return ptr::null_mut::<Icon>(),
    };
    
    let boxed: Box<Icon> = Box::new(proc);

    Box::into_raw(boxed)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_inject_stylesheet(
    ptr: *mut Icon,
    stylesheet: *mut c_char,
) -> *mut Icon {
    assert!(!ptr.is_null());
    assert!(!stylesheet.is_null());

    let stylesheet_string = CStr::from_ptr(stylesheet).to_str().unwrap();

    let icon = &*ptr;

    let proc = match icon.inject_stylesheet(stylesheet_string.to_string(), None) {
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
pub struct IkonaThemeList {
    pub theme_vec: Vec<IconTheme>
}

#[repr(C)]
pub struct IkonaDirectoryList {
    pub vec: *const Vec<IconDirectory>
}

#[repr(C)]
pub struct IkonaThemeIconList {
    pub vec: *const Vec<ThemeIcon>
}

#[repr(C)]
pub enum IkonaDirectoryType {
    Scalable,
    Threshold,
    Fixed,
    None
}

#[repr(C)]
pub enum IkonaDirectoryContext {
    Actions,
    Animations,
    Apps,
    Categories,
    Devices,
    Emblems,
    Emotes,
    Filesystems,
    International,
    Mimetypes,
    Places,
    Status,
    None
}

#[repr(C)]
pub struct IkonaDirectoryTypeData {
    pub dir_type: *const IconDirectoryType,
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_list_new() -> *mut IkonaThemeList {
    let mut list = match IconTheme::icon_themes() {
        Ok(res) => {
            let mut icon_theme_list = IkonaThemeList {
                theme_vec: res,
            };
            Box::new(icon_theme_list)
        },
        Err(err) => {
            println!("Error: {:?}", err);
            return ptr::null_mut::<IkonaThemeList>();
        }
    };

    Box::into_raw(list)
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_list_free(ptr: *mut IkonaThemeList) {
    assert!(!ptr.is_null());

    Box::from_raw(ptr);
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_list_get_length(ptr: *mut IkonaThemeList) -> u16 {
    assert!(!ptr.is_null());

    let theme = &*ptr;

    theme.theme_vec.len().try_into().unwrap()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_list_get_index(ptr: *mut IkonaThemeList, index: u16) -> *const IconTheme {
    assert!(!ptr.is_null());

    let theme = &*ptr;

    let mut pointer: *const IconTheme = &theme.theme_vec[usize::from(index)];

    pointer
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_get_root_path(ptr: *const IconTheme) -> *mut c_char {
    assert!(!ptr.is_null());

    let theme = &*ptr;

    CString::new(theme.root_path.clone()).expect("Failed to create CString").into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_get_name(ptr: *const IconTheme) -> *mut c_char {
    assert!(!ptr.is_null());

    let theme = &*ptr;

    CString::new(theme.name.clone()).expect("Failed to create CString").into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_get_display_name(ptr: *const IconTheme) -> *mut c_char {
    assert!(!ptr.is_null());

    let theme = &*ptr;

    CString::new(theme.display_name.clone()).expect("Failed to create CString").into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_get_directory_list(ptr: *const IconTheme) -> *mut IkonaDirectoryList {
    assert!(!ptr.is_null());

    let theme = &*ptr;

    Box::into_raw({
        Box::new({
            IkonaDirectoryList {
                vec: {
                    let ptr: *const Vec<IconDirectory> = &theme.directories;
                    ptr
                }
            }
        })
    })
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_list_free(ptr: *mut IkonaDirectoryList) {
    assert!(!ptr.is_null());

    Box::from_raw(ptr);
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_list_get_length(ptr: *mut IkonaDirectoryList) -> u16 {
    assert!(!ptr.is_null());

    let directory = &*ptr;
    let vec = &*directory.vec;

    vec.len().try_into().unwrap()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_list_get_index(ptr: *mut IkonaDirectoryList, index: u16) -> *const IconDirectory {
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

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_get_scale(ptr: *const IconDirectory) -> i32 {
    assert!(!ptr.is_null());

    let directory = &*ptr;

    match directory.scale {
        Some(scale) => scale,
        None => -1,
    }
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_get_type(ptr: *const IconDirectory) -> IkonaDirectoryType {
    assert!(!ptr.is_null());

    let directory = &*ptr;

    match directory.icon_type {
        Some(IconDirectoryType::Fixed) => IkonaDirectoryType::Fixed,
        Some(IconDirectoryType::Threshold { threshold }) => IkonaDirectoryType::Threshold,
        Some(IconDirectoryType::Scalable { max_size, min_size }) => IkonaDirectoryType::Scalable,
        None => IkonaDirectoryType::None,
    }
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_get_threshold(ptr: *const IconDirectory) -> i32 {
    assert!(!ptr.is_null());

    let directory = &*ptr;

    match directory.icon_type {
        Some(IconDirectoryType::Threshold { threshold }) => match threshold {
            Some(thresh) => thresh,
            None => -1,
        },
        _ => -1,
    }
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_get_max_size(ptr: *const IconDirectory) -> i32 {
    assert!(!ptr.is_null());

    let directory = &*ptr;

    match directory.icon_type {
        Some(IconDirectoryType::Scalable { max_size, min_size }) => match max_size {
            Some(scale) => scale,
            None => -1,
        },
        _ => -1,
    }
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_get_min_size(ptr: *const IconDirectory) -> i32 {
    assert!(!ptr.is_null());

    let directory = &*ptr;

    match directory.icon_type {
        Some(IconDirectoryType::Scalable { max_size, min_size }) => match min_size {
            Some(scale) => scale,
            None => -1,
        },
        _ => -1,
    }
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_get_location(ptr: *const IconDirectory) -> *mut c_char {
    assert!(!ptr.is_null());

    let directory = &*ptr;

    CString::new(directory.location.clone()).expect("Failed to create CString").into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_get_context(ptr: *const IconDirectory) -> IkonaDirectoryContext {
    assert!(!ptr.is_null());

    let directory = &*ptr;

    match directory.context {
        Some(IconContext::Actions) => IkonaDirectoryContext::Actions,
        Some(IconContext::Animations) => IkonaDirectoryContext::Animations,
        Some(IconContext::Apps) => IkonaDirectoryContext::Apps,
        Some(IconContext::Categories) => IkonaDirectoryContext::Categories,
        Some(IconContext::Devices) => IkonaDirectoryContext::Devices,
        Some(IconContext::Emblems) => IkonaDirectoryContext::Emblems,
        Some(IconContext::Emotes) => IkonaDirectoryContext::Emotes,
        Some(IconContext::Filesystems) => IkonaDirectoryContext::Filesystems,
        Some(IconContext::International) => IkonaDirectoryContext::International,
        Some(IconContext::Mimetypes) => IkonaDirectoryContext::Mimetypes,
        Some(IconContext::Places) => IkonaDirectoryContext::Places,
        Some(IconContext::Status) => IkonaDirectoryContext::Status,
        None => IkonaDirectoryContext::None,
    }
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_directory_get_icon_list(ptr: *const IconDirectory) -> *mut IkonaThemeIconList {
    assert!(!ptr.is_null());

    let directory = &*ptr;

    Box::into_raw({
        Box::new({
            IkonaThemeIconList {
                vec: {
                    let ptr: *const Vec<ThemeIcon> = &directory.icons;
                    ptr
                }
            }
        })
    })
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_list_free(ptr: *mut IkonaThemeIconList) {
    assert!(!ptr.is_null());

    Box::from_raw(ptr);
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_list_get_length(ptr: *mut IkonaThemeIconList) -> u16 {
    assert!(!ptr.is_null());

    let list = &*ptr;
    let vec = &*list.vec;

    vec.len().try_into().unwrap()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_icon_list_get_index(ptr: *mut IkonaThemeIconList, index: u16) -> *const ThemeIcon {
    assert!(!ptr.is_null());

    let list = &*ptr;
    let vec = &*list.vec;

    let mut pointer: *const ThemeIcon = &vec[usize::from(index)];

    pointer
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_icon_get_name(ptr: *const ThemeIcon) -> *mut c_char {
    assert!(!ptr.is_null());

    let icon = &*ptr;

    CString::new(icon.name.clone()).expect("Failed to create CString").into_raw()
}

#[no_mangle]
pub unsafe extern "C" fn ikona_theme_icon_get_location(ptr: *const ThemeIcon) -> *mut c_char {
    assert!(!ptr.is_null());

    let icon = &*ptr;

    CString::new(icon.location.clone()).expect("Failed to create CString").into_raw()
}

/*
 *  Other
 */

#[no_mangle]
pub unsafe extern "C" fn ikona_string_free(ptr: *mut c_char) {
    if !ptr.is_null() {
        CString::from_raw(ptr);
    }
}