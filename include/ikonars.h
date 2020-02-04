#ifdef __cplusplus
extern "C" {
#endif

typedef void* IkonaIcon;

IkonaIcon ikona_icon_new_from_path(const char* in_path);
IkonaIcon ikona_icon_new_from_string(const char* in_string);

const char* ikona_icon_get_filepath(IkonaIcon icon);

IkonaIcon ikona_icon_optimize_with_rsvg(IkonaIcon icon);
IkonaIcon ikona_icon_optimize_with_scour(IkonaIcon icon);
IkonaIcon ikona_icon_optimize_all(IkonaIcon icon);

IkonaIcon ikona_icon_class_as_light(IkonaIcon icon);
IkonaIcon ikona_icon_class_as_dark(IkonaIcon icon);

const char* ikona_icon_read_to_string(IkonaIcon icon);

IkonaIcon ikona_icon_extract_subicon_by_id(IkonaIcon icon, const char* id, int target_size);

void ikona_icon_free(IkonaIcon icon);

#ifdef __cplusplus
}
#endif