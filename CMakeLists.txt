cmake_minimum_required(VERSION 3.5)

project(ikona LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Widgets Quick REQUIRED)
find_package(KF5Kirigami2)
find_package(KF5ConfigWidgets)
find_package(KF5I18n)

# find_package(PkgConfig REQUIRED)
# pkg_check_modules(Cairo REQUIRED IMPORTED_TARGET cairo)
# pkg_check_modules(Rsvg REQUIRED IMPORTED_TARGET librsvg-2.0)
# pkg_check_modules(Glib REQUIRED IMPORTED_TARGET glib-2.0)
# pkg_check_modules(GObject REQUIRED IMPORTED_TARGET gobject-2.0)
# PkgConfig::Cairo PkgConfig::Rsvg PkgConfig::Glib PkgConfig::GObject
# See TODO in manip.cpp

FILE(GLOB_RECURSE HEADERS "include/*.h")

include_directories(include)

add_executable(ikona src/main.cpp src/manager.cpp src/icon.cpp src/manip.cpp qrc/qml/qml.qrc qrc/img/img.qrc ${HEADERS})

target_compile_definitions(ikona
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(ikona
  PRIVATE Qt5::Core Qt5::Widgets Qt5::Quick KF5::I18n KF5::Kirigami2 KF5::ConfigWidgets)

install(TARGETS ikona DESTINATION bin)
install(FILES data/org.kde.Ikona.desktop DESTINATION share/applications)
install(FILES data/org.kde.Ikona.svg DESTINATION share/icons/hicolor/scalable/apps)
install(FILES data/org.kde.Ikona.appdata.xml DESTINATION share/metainfo)
