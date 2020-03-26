use std::fs;
use std::path::{Path, PathBuf};

use dirs;
use ini::Ini;

#[repr(C)]
#[derive(Debug)]
pub enum IconDirectoryType {
    Scalable {
        max_size: Option<i32>,
        min_size: Option<i32>,
    },
    Threshold {
        threshold: Option<i32>,
    },
    Fixed,
}

#[repr(C)]
#[derive(Debug)]
pub enum IconContext {
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
}

#[repr(C)]
#[derive(Debug, Default)]
pub struct IconDirectory {
    pub size: i32,
    pub scale: Option<i32>,
    pub icon_type: Option<IconDirectoryType>,
    pub context: Option<IconContext>,
    pub location: String,
    pub icons: Vec<ThemeIcon>,
}

#[repr(C)]
#[derive(Debug)]
pub struct ThemeIcon {
    pub location: String,
    pub name: String,
}

#[repr(C)]
#[derive(Debug, Default)]
pub struct IconTheme {
    pub name: String,
    pub display_name: String,
    pub root_path: String,
    pub directories: Vec<IconDirectory>,
}

lazy_static! {
    static ref SEARCH_PATHS: Vec<String> = {
        let mut vec = vec![
            "/usr/share/icons".to_string(),
            "/usr/local/share/icons".to_string(),
        ];

        match dirs::home_dir() {
            Some(path) => {
                let mut path_mut = path;
                path_mut.push(".local");
                path_mut.push("share");
                path_mut.push("icons");
                match path_mut.to_str() {
                    Some(string) => vec.push(string.to_string()),
                    None => (),
                };
            }
            None => (),
        };

        vec
    };
}

fn grab_icon_directories() -> Vec<String> {
    let vec = {
        let mut vec: Vec<String> = Vec::new();
        for search_path in SEARCH_PATHS.iter() {
            let path = Path::new(search_path);
            if path.is_dir() {
                let dirs = match fs::read_dir(path) {
                    Ok(dirs) => dirs,
                    Err(err) => {
                        warn!("Error on line {}: {:#?}", line!(), err);
                        continue;
                    }
                };
                for entry in dirs {
                    let entry = match entry {
                        Ok(entry) => entry,
                        Err(err) => {
                            warn!("Error on line {}: {:#?}", line!(), err);
                            continue;
                        }
                    };
                    let path = entry.path();
                    let path_str = match path.to_str() {
                        Some(string) => string.to_string(),
                        None => {
                            warn!("continue on line {}", line!());
                            continue;
                        }
                    };
                    vec.push(path_str);
                }
            }
        }
        vec
    };

    vec
}

impl IconTheme {
    pub fn load_from_path(path: String) -> Result<IconTheme, String> {
        let pathbuf_dir: PathBuf = [path.clone()].iter().collect();
        let pathbuf: PathBuf = [path.clone(), "index.theme".to_string()].iter().collect();

        let mut icon_theme: IconTheme = Default::default();

        icon_theme.name = match pathbuf_dir.file_name() {
            Some(osstr) => match osstr.to_str() {
                Some(string) => string.to_string(),
                None => {
                    return Err(format!(
                        "continue on line {} at icon theme {:#?}",
                        line!(),
                        pathbuf
                    ));
                }
            },
            None => {
                return Err(format!(
                    "continue on line {} at icon theme {:#?}",
                    line!(),
                    pathbuf
                ));
            }
        };

        icon_theme.root_path = path.clone();
        let index_theme: Ini = match Ini::load_from_file(pathbuf.clone()) {
            Ok(ini) => ini,
            Err(err) => {
                return Err(format!(
                    "error on line {} at icon theme {:#?}: {:#?}",
                    line!(),
                    pathbuf,
                    err
                ));
            }
        };

        let icon_theme_section = match index_theme.section(Some("Icon Theme")) {
            Some(props) => props,
            None => {
                return Err(format!(
                    "continue on line {} at icon theme {:#?}",
                    line!(),
                    pathbuf
                ));
            }
        };

        icon_theme.display_name = match icon_theme_section.get("Name") {
            Some(value) => value.to_string(),
            None => {
                return Err(format!(
                    "continue on line {} at icon theme {:#?}",
                    line!(),
                    pathbuf
                ));
            }
        };

        let directories: Vec<String> = match icon_theme_section.get("Directories") {
            Some(value) => {
                let string = value.to_string();
                string.split(",").map(|s| s.to_string()).collect()
            }
            None => {
                return Err(format!(
                    "continue on line {} at icon theme {:#?}",
                    line!(),
                    pathbuf
                ));
            }
        };

        for dir in &directories {
            let directory: PathBuf = [&path, &(&dir).to_string()].iter().collect();
            let mut icon_dir: IconDirectory = Default::default();
            let sect = match index_theme.section(Some(dir)) {
                Some(sect) => sect,
                None => {
                    warn!("continue on line {} at icon theme {:#?}", line!(), pathbuf);
                    warn!("didn't find section for dir: {:#?}", dir);
                    continue;
                }
            };
            icon_dir.location = dir.clone();
            icon_dir.size = match sect.get("Size") {
                Some(size) => match size.parse::<i32>() {
                    Ok(val) => val,
                    Err(err) => {
                        warn!("Error on line {}: {:#?}", line!(), err);
                        continue;
                    }
                },
                None => {
                    warn!("continue on line {} at icon theme {:#?}", line!(), pathbuf);
                    continue;
                }
            };
            icon_dir.scale = match sect.get("Scale") {
                Some(scale) => match scale.parse::<i32>() {
                    Ok(val) => Some(val),
                    Err(err) => {
                        warn!("Error on line {}: {:#?}", line!(), err);
                        None
                    }
                },
                None => None,
            };
            icon_dir.context = match sect.get("Context") {
                Some(context) => match context {
                    "Actions" => Some(IconContext::Actions),
                    "Animations" => Some(IconContext::Animations),
                    "Apps" => Some(IconContext::Apps),
                    "Categories" => Some(IconContext::Categories),
                    "Devices" => Some(IconContext::Devices),
                    "Emblems" => Some(IconContext::Emblems),
                    "Emotes" => Some(IconContext::Emotes),
                    "Filesystems" => Some(IconContext::Filesystems),
                    "International" => Some(IconContext::International),
                    "Mimetypes" => Some(IconContext::Mimetypes),
                    "Places" => Some(IconContext::Places),
                    "Status" => Some(IconContext::Status),
                    _ => None,
                },
                None => None,
            };
            icon_dir.icon_type = match sect.get("Type") {
                Some(icon_type) => match icon_type {
                    "Fixed" => Some(IconDirectoryType::Fixed),
                    "Scalable" => Some(IconDirectoryType::Scalable {
                        max_size: match sect.get("MaxSize") {
                            Some(maxsize) => match maxsize.parse::<i32>() {
                                Ok(val) => Some(val),
                                Err(err) => {
                                    warn!("Error on line {}: {:#?}", line!(), err);
                                    None
                                }
                            },
                            None => {
                                warn!("continue on line {} at icon theme {:#?}", line!(), pathbuf);
                                continue;
                            }
                        },
                        min_size: match sect.get("MinSize") {
                            Some(minsize) => match minsize.parse::<i32>() {
                                Ok(val) => Some(val),
                                Err(err) => {
                                    warn!("Error on line {}: {:#?}", line!(), err);
                                    None
                                }
                            },
                            None => {
                                warn!("continue on line {} at icon theme {:#?}", line!(), pathbuf);
                                continue;
                            }
                        },
                    }),
                    "Threshold" => Some(IconDirectoryType::Threshold {
                        threshold: match sect.get("Threshold") {
                            Some(threshold) => match threshold.parse::<i32>() {
                                Ok(val) => Some(val),
                                Err(err) => {
                                    warn!("Error on line {}: {:#?}", line!(), err);
                                    Some(2)
                                }
                            },
                            None => Some(2),
                        },
                    }),
                    _ => None,
                },
                None => None,
            };

            if directory.is_dir() {
                let dirs = match fs::read_dir(directory) {
                    Ok(dirs) => dirs,
                    Err(err) => {
                        warn!("Error on line {}: {:#?}", line!(), err);
                        continue;
                    }
                };
                for entry in dirs {
                    let entry = match entry {
                        Ok(entry) => entry,
                        Err(err) => {
                            warn!("Error on line {}: {:#?}", line!(), err);
                            continue;
                        }
                    };
                    let path = entry.path();
                    let path_str = match path.to_str() {
                        Some(string) => string.to_string(),
                        None => {
                            warn!("continue on line {} at icon theme {:#?}", line!(), pathbuf);
                            continue;
                        }
                    };
                    icon_dir.icons.push(ThemeIcon {
                        location: path_str.clone(),
                        name: {
                            let path = Path::new(&path_str);
                            match path.file_stem() {
                                Some(osstr) => match osstr.to_str() {
                                    Some(string) => string.to_string(),
                                    None => {
                                        warn!(
                                            "continue on line {} at icon theme {:#?}",
                                            line!(),
                                            pathbuf
                                        );
                                        continue;
                                    }
                                },
                                None => {
                                    warn!(
                                        "continue on line {} at icon theme {:#?}",
                                        line!(),
                                        pathbuf
                                    );
                                    continue;
                                }
                            }
                        },
                    });
                }
            }

            icon_theme.directories.push(icon_dir);
        }

        Ok(icon_theme)
    }

    pub fn icon_themes() -> Result<Vec<IconTheme>, String> {
        let search_path = grab_icon_directories();
        let mut theme: Vec<IconTheme> = Vec::new();

        for path in search_path {
            let icon_theme = match IconTheme::load_from_path(path) {
                Ok(theme) => theme,
                Err(err) => continue,
            };
            theme.push(icon_theme);
        }

        Ok(theme)
    }

    pub fn load_from_name(name: String) -> Result<IconTheme, String> {
        let search_path = grab_icon_directories();

        for path in search_path {
            let pathbuf = PathBuf::from(path.clone());
            match pathbuf.file_name() {
                Some(osstr) => match osstr.to_str() {
                    Some(string) => {
                        if string == name {
                            return IconTheme::load_from_path(path);
                        }
                    }
                    None => continue,
                },
                None => continue,
            }
        }

        Err("No icon theme found".to_string())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    pub fn test_new_from_name() {
        use pretty_env_logger;

        pretty_env_logger::init();

        let icon_themes = IconTheme::load_from_name("oxygen".to_string()).unwrap();
        warn!("{:#?}", icon_themes);
    }
}
