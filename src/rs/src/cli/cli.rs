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

use clap;
use clap::App;
use std::io;
use std::fs;
use ikona::icons::IkonaIcon;

fn optimize(matches: clap::ArgMatches) {
    // If we got here, we already know that our subcommand is optimize.
    let subcommand_matches = matches.subcommand_matches("optimize").unwrap();
    let file = subcommand_matches.value_of("input").unwrap().to_owned();
    let file_two = subcommand_matches.value_of("input").unwrap().to_owned();
    let icon = match IkonaIcon::new_from_path(file) {
        Ok(icon) => icon,
        Err(err) => {
            println!("{}", err);
            return;
        }
    };
    let proc = match subcommand_matches.value_of("mode") {
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
        _ => panic!("We shouldn't be able to get to this program state!")
    };
    if subcommand_matches.is_present("inplace") {
        match fs::copy(proc.get_filepath(), file_two) {
            Ok(_) => println!("Icon optimized"),
            Err(_) => println!("Icon failed to optimize"),
        }
    } else {
        if let Some(output) = subcommand_matches.value_of("output") {
            match fs::copy(proc.get_filepath(), output) {
                Ok(_) => println!("Icon optimized"),
                Err(_) => println!("Icon failed to optimize")
            }
        } else {
            println!("Please specify an output file");
            return
        }
    }
}

fn class(matches: clap::ArgMatches) {
    // If we got here, we already know that our subcommand is class.
    let subcommand_matches = matches.subcommand_matches("class").unwrap();
    let file = subcommand_matches.value_of("input").unwrap().to_owned();
    let file_two = subcommand_matches.value_of("input").unwrap().to_owned();
    let icon = match IkonaIcon::new_from_path(file) {
        Ok(icon) => icon,
        Err(err) => {
            println!("{}", err);
            return;
        }
    };
    let proc = match subcommand_matches.value_of("mode") {
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
        _ => panic!("We shouldn't be able to get to this program state!")
    };
    if subcommand_matches.is_present("inplace") {
        match fs::copy(proc.get_filepath(), file_two) {
            Ok(_) => println!("Icon classed"),
            Err(_) => println!("Icon failed to class"),
        }
    } else {
        if let Some(output) = subcommand_matches.value_of("output") {
            match fs::copy(proc.get_filepath(), output) {
                Ok(_) => println!("Icon classed"),
                Err(_) => println!("Icon failed to class")
            }
        } else {
            println!("Please specify an output file");
            return
        }
    }
}

fn convert(matches: clap::ArgMatches) {
    // If we got here, we already know that our subcommand is convert.
    let subcommand_matches = matches.subcommand_matches("convert").unwrap();
    let file = subcommand_matches.value_of("input").unwrap().to_owned();
    let file_two = subcommand_matches.value_of("input").unwrap().to_owned();
    let icon = match IkonaIcon::new_from_path(file) {
        Ok(icon) => icon,
        Err(err) => {
            println!("{}", err);
            return;
        }
    };
    let proc = match subcommand_matches.value_of("light") {
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
        _ => panic!("We shouldn't be able to get to this program state!")
    };
    if subcommand_matches.is_present("inplace") {
        match fs::copy(proc.get_filepath(), file_two) {
            Ok(_) => println!("Icon converted"),
            Err(_) => println!("Icon failed to convert"),
        }
    } else {
        if let Some(output) = subcommand_matches.value_of("output") {
            match fs::copy(proc.get_filepath(), output) {
                Ok(_) => println!("Icon converted"),
                Err(_) => println!("Icon failed to convert")
            }
        } else {
            println!("Please specify an output file");
            return
        }
    }
}

fn extract(matches: clap::ArgMatches) {
    let subcommand_matches = matches.subcommand_matches("extract").unwrap();
    let input = subcommand_matches.value_of("input").unwrap().to_owned();
    let (id, size) = match subcommand_matches.value_of("size").unwrap() {
        "16" => ("#16plate", 16),
        "22" => ("#22plate", 22),
        "32" => ("#32plate", 32),
        "48" => ("#48plate", 48),
        "64" => ("#64plate", 64),
        _ => ("#48plate", 48),
    };
    let output = subcommand_matches.value_of("output").unwrap().to_owned();

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
        Ok(_) => println!("Icon extracted"),
        Err(_) => println!("Icon failed to extract"),
    }
}

fn main() {
    let yaml = clap::load_yaml!("cli.yaml");
    let app = App::from(yaml);
    let app_matches = App::from(yaml);
    let matches = app_matches.get_matches();

    match matches.subcommand_name() {
        Some("optimize") => optimize(matches),
        Some("class") => class(matches),
        Some("convert") => convert(matches),
        Some("extract") => extract(matches),
        None => {
            let mut out = io::stdout();
            app.write_help(&mut out).expect("Failed to write to stdout");
        },
        _ => {
            let mut out = io::stdout();
            app.write_help(&mut out).expect("Failed to write to stdout");
        }
    }
}