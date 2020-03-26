#pragma once

#ifdef __cplusplus
extern "C" {
#endif

// Icon Manipulation

typedef void* IkonaIcon;

IkonaIcon ikona_icon_new_from_path(const char* in_path);
IkonaIcon ikona_icon_new_from_string(const char* in_string);

char* ikona_icon_get_filepath(IkonaIcon icon);

IkonaIcon ikona_icon_optimize_with_rsvg(IkonaIcon icon);
IkonaIcon ikona_icon_optimize_with_scour(IkonaIcon icon);
IkonaIcon ikona_icon_optimize_all(IkonaIcon icon);

IkonaIcon ikona_icon_class_as_light(IkonaIcon icon);
IkonaIcon ikona_icon_class_as_dark(IkonaIcon icon);

char* ikona_icon_read_to_string(IkonaIcon icon);

IkonaIcon ikona_icon_extract_subicon_by_id(IkonaIcon icon, const char* id, int target_size);
IkonaIcon ikona_icon_crop_to_subicon(IkonaIcon icon, const char* id, int target_size);
IkonaIcon ikona_icon_inject_stylesheet(IkonaIcon icon, const char* stylesheet);

void ikona_icon_free(IkonaIcon icon);

// Icon Themes

typedef void* IkonaThemeList;
typedef const void* IkonaTheme;
typedef void* IkonaDirectoryList;
typedef const void* IkonaThemeDirectory;
typedef void* IkonaThemeIconList;
typedef const void* IkonaThemeIcon;
typedef enum {
  ScalableType,
  ThresholdType,
  FixedType,
  NoType,
} IkonaDirectoryType;
typedef enum {
  ActionsContext,
  AnimationsContext,
  AppsContext,
  CategoriesContext,
  DevicesContext,
  EmblemsContext,
  EmotesContext,
  FilesystemsContext,
  InternationalContext,
  MimetypesContext,
  PlacesContext,
  StatusContext,
  NoContext
} IkonaDirectoryContext;

void ikona_string_free(char* string);

IkonaThemeList ikona_theme_list_new(void);
void ikona_theme_list_free(IkonaThemeList list);

uint16_t ikona_theme_list_get_length(IkonaThemeList list);
IkonaTheme ikona_theme_list_get_index(IkonaThemeList list, uint16_t index);

char* ikona_theme_get_name(IkonaTheme theme);
char* ikona_theme_get_display_name(IkonaTheme theme);
char* ikona_theme_get_root_path(IkonaTheme theme);

IkonaDirectoryList ikona_theme_get_directory_list(IkonaTheme theme);
void ikona_theme_directory_list_free(IkonaDirectoryList list);

uint16_t ikona_theme_directory_list_get_length(IkonaDirectoryList list);
IkonaThemeDirectory ikona_theme_directory_list_get_index(IkonaDirectoryList list, uint16_t index);

int ikona_theme_directory_get_size(IkonaThemeDirectory directory);
int ikona_theme_directory_get_scale(IkonaThemeDirectory directory);
IkonaDirectoryType ikona_theme_directory_get_type(IkonaThemeDirectory directory);
IkonaDirectoryContext ikona_theme_directory_get_context(IkonaThemeDirectory directory);

int ikona_theme_directory_get_threshold(IkonaThemeDirectory directory);

int ikona_theme_directory_get_max_size(IkonaThemeDirectory directory);
int ikona_theme_directory_get_min_size(IkonaThemeDirectory directory);

char* ikona_theme_directory_get_location(IkonaThemeDirectory directory);

IkonaThemeIconList ikona_theme_directory_get_icon_list(IkonaThemeDirectory directory);

void ikona_icon_list_free(IkonaThemeIconList list);

uint16_t ikona_icon_list_get_length(IkonaThemeIconList list);
IkonaThemeIcon ikona_icon_list_get_index(IkonaThemeIconList list, uint16_t index);

char* ikona_theme_icon_get_name(IkonaThemeIcon icon);
char* ikona_theme_icon_get_location(IkonaThemeIcon icon);

#ifdef __cplusplus
}
#endif
