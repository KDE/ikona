use clap;
use clap::App;
use std::io;
use std::fs;
use ikona::Ikona;

fn optimize(matches: clap::ArgMatches) {
    // If we got here, we already know that our subcommand is optimize.
    let subcommand_matches = matches.subcommand_matches("optimize").unwrap();
    let file = subcommand_matches.value_of("input").unwrap().to_owned();
    let file_two = subcommand_matches.value_of("input").unwrap().to_owned();
    let icon = match Ikona::Icon::new_from_path(Box::leak(file.into_boxed_str())) {
        Ok(icon) => icon,
        Err(err) => {
            println!("{}", err);
            return;
        }
    };
    let proc = match subcommand_matches.value_of("mode") {
        Some("all") | None => match icon.optimize_all() {
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
        Some("scour") => match icon.optimize_with_scour() {
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
    let icon = match Ikona::Icon::new_from_path(Box::leak(file.into_boxed_str())) {
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

fn main() {
    let yaml = clap::load_yaml!("cli.yaml");
    let app = App::from(yaml);
    let app_matches = App::from(yaml);
    let matches = app_matches.get_matches();

    match matches.subcommand_name() {
        Some("optimize") => optimize(matches),
        Some("class") => class(matches),
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