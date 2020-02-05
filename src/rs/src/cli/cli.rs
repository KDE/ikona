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

use clap::{App, Arg, SubCommand};
use gettextrs::*;
use ikona::icons::IkonaIcon;
use std::fs;
use std::io;

/*
 * i18n note: For Rust reasons, adding comments to the macro below
 * will cause build errors. Sorry about not being able to leave comments
 * that xgettext will be able to pick up.
 */

macro_rules! app {
    () => {
        App::new("ikona-cli")
            .version("1.0")
            .author("Carson Black <uhhadd@gmail.com>")
            .about(&*gettext("Command-line interface to Ikona"))
            .subcommand(
                SubCommand::with_name(&gettext("optimize"))
                    .about(&*gettext("Optimize your icon"))
                    .arg(
                        Arg::with_name(&gettext("input"))
                            .help(&gettext("Sets the input file to read from"))
                            .required(true)
                            .index(1),
                    )
                    .arg(
                        Arg::with_name(&gettext("output"))
                            .help(&gettext("Sets the output file to write to"))
                            .index(2),
                    )
                    .arg(
                        Arg::with_name(&gettext("mode"))
                            .short(&gettext("m"))
                            .long(&gettext("mode"))
                            .help(&gettext("Sets optimization method to use"))
                            .possible_values(&["all", "rsvg", "scour"])
                            .takes_value(true),
                    )
                    .arg(
                        Arg::with_name(&gettext("inplace"))
                            .short(&gettext("i"))
                            .long(&gettext("inplace"))
                            .help(&gettext("Modifies the icon in-place"))
                            .conflicts_with(&gettext("output")),
                    ),
            )
            .subcommand(
                SubCommand::with_name(&gettext("class"))
                    .about(&*gettext("Class your icon"))
                    .arg(
                        Arg::with_name(&gettext("input"))
                            .help(&gettext("Sets the input file to read from"))
                            .required(true)
                            .index(1),
                    )
                    .arg(
                        Arg::with_name(&gettext("output"))
                            .help(&gettext("Sets the output file to write to"))
                            .index(2),
                    )
                    .arg(
                        Arg::with_name(&gettext("mode"))
                            .short(&gettext("m"))
                            .long(&gettext("mode"))
                            .help(&gettext("Sets what type of icon to treat the icon as"))
                            .possible_values(&["light", "dark"])
                            .takes_value(true)
                            .required(true),
                    )
                    .arg(
                        Arg::with_name(&gettext("inplace"))
                            .short(&gettext("i"))
                            .long(&gettext("inplace"))
                            .help(&gettext("Modifies the icon in-place"))
                            .conflicts_with(&gettext("output")),
                    ),
            )
            .subcommand(
                SubCommand::with_name(&gettext("convert"))
                    .about(&*gettext("Convert your icon from light <-> dark"))
                    .arg(
                        Arg::with_name(&gettext("input"))
                            .help(&gettext("Sets the input file to read from"))
                            .required(true)
                            .index(1),
                    )
                    .arg(
                        Arg::with_name(&gettext("output"))
                            .help(&gettext("Sets the output file to read from"))
                            .index(2),
                    )
                    .arg(
                        Arg::with_name(&gettext("target"))
                            .short(&gettext("t"))
                            .long(&gettext("target"))
                            .help(&gettext("Sets the type of icon to convert to"))
                            .possible_values(&["light", "dark"])
                            .takes_value(true)
                            .required(true),
                    )
                    .arg(
                        Arg::with_name(&gettext("inplace"))
                            .short(&gettext("i"))
                            .long(&gettext("inplace"))
                            .help(&gettext("Modifies the icon in-place"))
                            .conflicts_with(&gettext("output")),
                    ),
            )
            .subcommand(
                SubCommand::with_name(&gettext("extract"))
                    .about(&*gettext("Extract icons from an Ikona template file"))
                    .arg(
                        Arg::with_name(&gettext("input"))
                            .help(&gettext("Sets the input file to read from"))
                            .required(true)
                            .index(1),
                    )
                    .arg(
                        Arg::with_name(&gettext("size"))
                            .help(&gettext("Sets the size of icon you want to extract"))
                            .required(true)
                            .index(2)
                            .possible_values(&["16", "22", "32", "48", "64"]),
                    )
                    .arg(
                        Arg::with_name(&gettext("output"))
                            .help(&gettext("Sets the output file to write to"))
                            .required(true)
                            .index(3),
                    ),
            )
    };
}

macro_rules! subcommand_matches {
    ($subcommand: expr) => {
        app!()
            .get_matches()
            .subcommand_matches($subcommand)
            .unwrap()
    };
}

fn optimize() {
    // If we got here, we already know that our subcommand is optimize.
    let file = subcommand_matches!(gettext("optimize"))
        .value_of(gettext("input"))
        .unwrap()
        .to_owned();
    let file_two = subcommand_matches!(gettext("optimize"))
        .value_of(gettext("input"))
        .unwrap()
        .to_owned();
    let icon = match IkonaIcon::new_from_path(file) {
        Ok(icon) => icon,
        Err(err) => {
            println!("{}", err);
            return;
        }
    };
    let proc = match subcommand_matches!(gettext("optimize")).value_of(gettext("mode")) {
        Some("all") => match icon.optimize_all() {
            Ok(icon) => icon,
            Err(err) => {
                println!("{}", err);
                return;
            }
        },
        Some("rsvg") => match icon.optimize_with_rsvg() {
            Ok(icon) => (icon),
            Err(err) => {
                println!("{}", err);
                return;
            }
        },
        Some("scour") | None => match icon.optimize_with_scour() {
            Ok(icon) => (icon),
            Err(err) => {
                println!("{}", err);
                return;
            }
        },
        _ => panic!("We shouldn't be able to get to this program state!"),
    };
    if subcommand_matches!(gettext("optimize")).is_present(gettext("inplace")) {
        match fs::copy(proc.get_filepath(), file_two) {
            Ok(_) => {
                println!("{}", gettext("Icon optimized"));
                return;
            }
            Err(_) => {
                println!("{}", gettext("Icon failed to optimize"));
                return;
            }
        }
    } else {
        if let Some(output) = subcommand_matches!(gettext("optimize")).value_of(gettext("output")) {
            match fs::copy(proc.get_filepath(), output) {
                Ok(_) => {
                    println!("{}", gettext("Icon optimized"));
                    return;
                }
                Err(_) => {
                    println!("{}", gettext("Icon failed to optimize"));
                    return;
                }
            }
        }
        println!("{}", gettext("Please specify an output file"));
    }
}

fn class() {
    // If we got here, we already know that our subcommand is class.
    let file = subcommand_matches!(gettext("class"))
        .value_of(gettext("input"))
        .unwrap()
        .to_owned();
    let file_two = subcommand_matches!(gettext("class"))
        .value_of(gettext("input"))
        .unwrap()
        .to_owned();
    let icon = match IkonaIcon::new_from_path(file) {
        Ok(icon) => icon,
        Err(err) => {
            println!("{}", err);
            return;
        }
    };
    let proc = match subcommand_matches!(gettext("class")).value_of(gettext("mode")) {
        Some("light") | None => match icon.class_as_light() {
            Ok(icon) => icon,
            Err(err) => {
                println!("{}", err);
                return;
            }
        },
        Some("dark") => match icon.class_as_dark() {
            Ok(icon) => (icon),
            Err(err) => {
                println!("{}", err);
                return;
            }
        },
        _ => panic!("We shouldn't be able to get to this program state!"),
    };
    if subcommand_matches!(gettext("class")).is_present(gettext("inplace")) {
        match fs::copy(proc.get_filepath(), file_two) {
            Ok(_) => {
                println!("{}", gettext("Icon classed"));
                return;
            }
            Err(_) => {
                println!("{}", gettext("Icon failed to class"));
                return;
            }
        }
    } else {
        if let Some(output) = subcommand_matches!(gettext("class")).value_of(gettext("output")) {
            match fs::copy(proc.get_filepath(), output) {
                Ok(_) => {
                    println!("{}", gettext("Icon classed"));
                    return;
                }
                Err(_) => {
                    println!("{}", gettext("Icon failed to class"));
                    return;
                }
            }
        }
        println!("{}", gettext("Please specify an output file"));
    }
}

fn convert() {
    // If we got here, we already know that our subcommand is convert.
    let file = subcommand_matches!(gettext("convert"))
        .value_of(gettext("input"))
        .unwrap()
        .to_owned();
    let file_two = subcommand_matches!(gettext("convert"))
        .value_of(gettext("input"))
        .unwrap()
        .to_owned();
    let icon = match IkonaIcon::new_from_path(file) {
        Ok(icon) => icon,
        Err(err) => {
            println!("{}", err);
            return;
        }
    };
    let proc = match subcommand_matches!(gettext("convert")).value_of(gettext("light")) {
        Some("light") | None => match icon.convert_to_light_from_dark() {
            Ok(icon) => icon,
            Err(err) => {
                println!("{}", err);
                return;
            }
        },
        Some("dark") => match icon.convert_to_dark_from_light() {
            Ok(icon) => (icon),
            Err(err) => {
                println!("{}", err);
                return;
            }
        },
        _ => panic!("We shouldn't be able to get to this program state!"),
    };
    if subcommand_matches!(gettext("convert")).is_present(gettext("inplace")) {
        match fs::copy(proc.get_filepath(), file_two) {
            Ok(_) => {
                println!("{}", gettext("Icon converted"));
                return;
            }
            Err(_) => {
                println!("{}", gettext("Icon failed to convert"));
                return;
            }
        }
    } else {
        if let Some(output) = subcommand_matches!(gettext("convert")).value_of(gettext("output")) {
            match fs::copy(proc.get_filepath(), output) {
                Ok(_) => {
                    println!("{}", gettext("Icon converted"));
                    return;
                }
                Err(_) => {
                    println!("{}", gettext("Icon failed to convert"));
                    return;
                }
            }
        }
        println!("{}", gettext("Please specify an output file"));
    }
}

fn extract() {
    let input = subcommand_matches!(gettext("extract"))
        .value_of(gettext("input"))
        .unwrap()
        .to_owned();
    let (id, size) = match subcommand_matches!(gettext("extract"))
        .value_of(gettext("size"))
        .unwrap()
    {
        "16" => ("#16plate", 16),
        "22" => ("#22plate", 22),
        "32" => ("#32plate", 32),
        "48" => ("#48plate", 48),
        "64" => ("#64plate", 64),
        _ => ("#48plate", 48),
    };
    let output = subcommand_matches!(gettext("extract"))
        .value_of(gettext("output"))
        .unwrap()
        .to_owned();

    let icon = match IkonaIcon::new_from_path(input) {
        Ok(icon) => icon,
        Err(err) => {
            println!("{}", err);
            return;
        }
    };
    let subicon = match icon.extract_subicon_by_id(id, size) {
        Ok(subicon) => subicon,
        Err(err) => {
            println!("{}", err);
            return;
        }
    };

    match fs::copy(subicon.get_filepath(), output) {
        Ok(_) => {
            println!("{}", gettext("Icon extracted"));
            return;
        }
        Err(_) => println!("{}", gettext("Icon failed to extract")),
    }
}

fn main() {
    TextDomain::new("ikonacli").init();

    match app!().get_matches().subcommand_name() {
        Some("optimize") => optimize(),
        Some("class") => class(),
        Some("convert") => convert(),
        Some("extract") => extract(),
        None => {
            let mut out = io::stdout();
            app!()
                .write_help(&mut out)
                .expect("Failed to write to stdout");
        }
        _ => {
            let mut out = io::stdout();
            app!()
                .write_help(&mut out)
                .expect("Failed to write to stdout");
        }
    };
}
