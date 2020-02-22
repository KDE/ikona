use super::Icon;
use std::collections::HashMap;

pub trait GnomeIcon {
    fn class(&self) -> Result<Icon, String>;
}

impl GnomeIcon for Icon {
    // Returns an `Icon` with colours replaced with classes.
    fn class(&self) -> Result<Icon, String> {
        let mut map = HashMap::new();

        map.insert(
            "#f57900".to_string(),
            "warning".to_string(),
        );
        map.insert(
            "#cc0000".to_string(),
            "error".to_string(),
        );
        map.insert(
            "#33d17a".to_string(),
            "success".to_string(),
        );
        map.insert(
            "#26ab62".to_string(),
            "success".to_string(),
        );

        self.replace_colours_with_classes(map, true, None)
    }
}