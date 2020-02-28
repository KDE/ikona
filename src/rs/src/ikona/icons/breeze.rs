use super::Icon;
use std::collections::HashMap;

pub trait BreezeIcon {
    fn convert_to_dark_from_light(&self) -> Result<Icon, String>;
    fn convert_to_light_from_dark(&self) -> Result<Icon, String>;
    fn class_as_dark(&self) -> Result<Icon, String>;
    fn class_as_light(&self) -> Result<Icon, String>;
}

impl BreezeIcon for Icon {
    /// Returns an `Icon` with a dark colour palette.
    fn convert_to_dark_from_light(&self) -> Result<Icon, String> {
        let mut icon_str_mut = self.read_to_string()?;

        if !icon_str_mut.contains("#31363b") {
            icon_str_mut = icon_str_mut.replace("#eff0f1", "#31363b");
            icon_str_mut = icon_str_mut.replace("#232629", "#eff0f1");
            icon_str_mut = icon_str_mut.replace("#fcfcfc", "#232629");
        }

        Icon::new_from_string(icon_str_mut)
    }
    /// Returns an `Icon` with a light colour palette.
    fn convert_to_light_from_dark(&self) -> Result<Icon, String> {
        let mut icon_str_mut = self.read_to_string()?;

        if !icon_str_mut.contains("#fcfcfc") {
            icon_str_mut = icon_str_mut.replace("#232629", "#fcfcfc");
            icon_str_mut = icon_str_mut.replace("#eff0f1", "#232629");
            icon_str_mut = icon_str_mut.replace("#31363b", "#eff0f1");
        }

        Icon::new_from_string(icon_str_mut)
    }
    /// Injects CSS and replaces hardcoded colours according to a dark
    /// colour palette.
    fn class_as_dark(&self) -> Result<Icon, String> {
        let mut map = HashMap::new();

        map.insert("#eff0f1".to_string(), "Text".to_string());
        map.insert("#31363b".to_string(), "Background".to_string());
        map.insert("#232629".to_string(), "ViewBackground".to_string());
        map.insert("#3daee9".to_string(), "ButtonFocus".to_string());
        map.insert("#27ae60".to_string(), "PositiveText".to_string());
        map.insert("#f67400".to_string(), "NeutralText".to_string());
        map.insert("#da4453".to_string(), "NegativeText".to_string());

        self.replace_colours_with_classes(map, true, Some("current-color-scheme".to_string()))
    }
    /// Injects CSS and replaces hardcoded colours according to a light
    /// colour palette.
    fn class_as_light(&self) -> Result<Icon, String> {
        let mut map = HashMap::new();

        map.insert("#232629".to_string(), "Text".to_string());
        map.insert("#eff0f1".to_string(), "Background".to_string());
        map.insert("#fcfcfc".to_string(), "ViewBackground".to_string());
        map.insert("#3daee9".to_string(), "ButtonFocus".to_string());
        map.insert("#27ae60".to_string(), "PositiveText".to_string());
        map.insert("#f67400".to_string(), "NeutralText".to_string());
        map.insert("#da4453".to_string(), "NegativeText".to_string());

        self.replace_colours_with_classes(map, true, Some("current-color-scheme".to_string()))
    }
}
