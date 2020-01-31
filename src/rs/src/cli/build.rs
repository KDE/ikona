use clap;
use clap::{App, Shell};
use std::env;

fn main() {
    let yaml = clap::load_yaml!("cli.yaml");
    let mut app = App::from(yaml);
    app.gen_completions("ikona-cli", Shell::Bash, format!("{}/../../..", env::var("OUT_DIR").unwrap()));
    app.gen_completions("ikona-cli", Shell::Fish, format!("{}/../../..", env::var("OUT_DIR").unwrap()));
    app.gen_completions("ikona-cli", Shell::Zsh, format!("{}/../../..", env::var("OUT_DIR").unwrap()));
    println!("env: {}", format!("{}/../../..", env::var("OUT_DIR").unwrap()));
} 