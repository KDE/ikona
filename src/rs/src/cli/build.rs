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