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

use super::Icon;

#[test]
fn test_classing_light() {
    use super::breeze::BreezeIcon;

    let data = include_str!("before/classing/timer.svg");
    let data_expected = include_str!("after/classing/timer.svg");

    let icon = Icon::new_from_string(data.to_string()).unwrap();

    let processed = icon.class_as_light().unwrap();

    let processed_str = processed.read_to_string().unwrap();

    assert_eq!(processed_str, data_expected);
}

#[test]
fn test_classing_dark() {
    use super::breeze::BreezeIcon;

    let data = include_str!("before/classing/timer-dark.svg");
    let data_expected = include_str!("after/classing/timer-dark.svg");

    let icon = Icon::new_from_string(data.to_string()).unwrap();

    let processed = icon.class_as_dark().unwrap();

    let processed_str = processed.read_to_string().unwrap();

    assert_eq!(processed_str, data_expected);
}

#[test]
fn test_classing_non_icon() {
    use super::breeze::BreezeIcon;

    let data = include_str!("before/classing/kai okular.svg");
    let data_expected = include_str!("after/classing/kai okular.svg");

    let icon = Icon::new_from_string(data.to_string()).unwrap();

    let processed = icon.class_as_light().unwrap();

    let processed_str = processed.read_to_string().unwrap();

    assert_eq!(processed_str, data_expected);
}
