use super::IkonaIcon;

#[test]
fn test_classing_light() {
    let data = include_str!("before/classing/timer.svg");
    let data_expected = include_str!("after/classing/timer.svg");

    let icon = IkonaIcon::new_from_string(data.to_string()).unwrap();

    let processed = icon.class_as_light().unwrap();

    let processed_str = processed.read_to_string().unwrap();

    assert_eq!(processed_str, data_expected);
}

#[test]
fn test_classing_dark() {
    let data = include_str!("before/classing/timer-dark.svg");
    let data_expected = include_str!("after/classing/timer-dark.svg");

    let icon = IkonaIcon::new_from_string(data.to_string()).unwrap();

    let processed = icon.class_as_dark().unwrap();

    let processed_str = processed.read_to_string().unwrap();

    assert_eq!(processed_str, data_expected);
}

#[test]
fn test_classing_non_icon() {
    let data = include_str!("before/classing/kai okular.svg");
    let data_expected = include_str!("after/classing/kai okular.svg");

    let icon = IkonaIcon::new_from_string(data.to_string()).unwrap();

    let processed = icon.class_as_light().unwrap();

    let processed_str = processed.read_to_string().unwrap();

    assert_eq!(processed_str, data_expected);
}