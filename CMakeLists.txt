cmake_minimum_required(VERSION 3.5)

project(ikona LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC OFF) # ki18n integration needs explicit use of ki18n_wrap_ui
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)

set(REQUIRED_QT_VERSION 5.13.0)

find_package(Qt5 COMPONENTS Core Widgets Quick Concurrent REQUIRED)
find_package(KF5Kirigami2)
find_package(KF5ConfigWidgets)
find_package(KF5I18n)
find_package(PkgConfig REQUIRED)

pkg_check_modules(cairo REQUIRED IMPORTED_TARGET cairo)
pkg_check_modules(cairo-png REQUIRED IMPORTED_TARGET cairo-png)
pkg_check_modules(cairo-gobject REQUIRED IMPORTED_TARGET cairo-gobject)
pkg_check_modules(fontconfig REQUIRED IMPORTED_TARGET fontconfig)
pkg_check_modules(freetype2 REQUIRED IMPORTED_TARGET freetype2)
pkg_check_modules(gdk-pixbuf-2.0 REQUIRED IMPORTED_TARGET gdk-pixbuf-2.0)
pkg_check_modules(gio-2.0 REQUIRED IMPORTED_TARGET gio-2.0)
pkg_check_modules(gio-unix-2.0 REQUIRED IMPORTED_TARGET gio-unix-2.0)
pkg_check_modules(glib-2.0 REQUIRED IMPORTED_TARGET glib-2.0)
pkg_check_modules(gmodule-2.0 REQUIRED IMPORTED_TARGET gmodule-2.0)
pkg_check_modules(gthread-2.0 REQUIRED IMPORTED_TARGET gthread-2.0)
pkg_check_modules(libxml-2.0 REQUIRED IMPORTED_TARGET libxml-2.0)
pkg_check_modules(pangocairo REQUIRED IMPORTED_TARGET pangocairo)
pkg_check_modules(pangoft2 REQUIRED IMPORTED_TARGET pangoft2)

# rust

option(withsvgcleaner "Build Ikona with svgcleaner crate. Note that this results in GPL2 binaries." OFF)

string(TOUPPER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_UPPER)
if(CMAKE_BUILD_TYPE_UPPER STREQUAL DEBUG)
    set(RUST_TARGET_DIR target/debug/)
    set(RUST_BUILD_FLAG)
else()
    set(RUST_TARGET_DIR target/release/)
    set(RUST_BUILD_FLAG --release)
endif()

if(withsvgcleaner)
    list(APPEND ${RUST_BUILD_FLAG} --features with-svgcleaner)
endif()

SET(RUST_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/rs")
SET(RUST_LIB "${RUST_DIR}/${RUST_TARGET_DIR}/libikonars.a")
SET(RUST_BIN "${RUST_DIR}/${RUST_TARGET_DIR}/ikona-cli")
SET(ZSH_COMPL "${RUST_DIR}/${RUST_TARGET_DIR}/_ikona-cli")
SET(BASH_COMPL "${RUST_DIR}/${RUST_TARGET_DIR}/ikona-cli.bash")
SET(FISH_COMPL "${RUST_DIR}/${RUST_TARGET_DIR}/ikona-cli.fish")

find_program(Cargo NAMES cargo)

add_custom_command(
  OUTPUT "${RUST_LIB}"
  COMMAND ${Cargo} build ${RUST_BUILD_FLAG}
  DEPENDS src/rs/src/ikona/icons/mod.rs
          src/rs/src/ikona/icontheme/mod.rs
          src/rs/src/ikona/icons/tests.rs
          src/rs/src/ikona/lib.rs
          src/rs/src/capi/capi.rs
  WORKING_DIRECTORY "${RUST_DIR}"
)

if(EXISTS ${CMAKE_SOURCE_DIR}/ikona.cargo.vendor.tar.xz)
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar xvf ${CMAKE_SOURCE_DIR}/ikona.cargo.vendor.tar.xz
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/src/rs/
    )
    configure_file(
        ${CMAKE_SOURCE_DIR}/cargo-vendor-config.toml
        ${CMAKE_SOURCE_DIR}/src/rs/.cargo/config
        COPYONLY
    )
endif()

add_custom_target(rust_target DEPENDS "${RUST_LIB}")

# end rust

FILE(GLOB_RECURSE HEADERS "include/*.h")

include_directories(include)

add_executable(ikona src/main.cpp src/manager.cpp src/icon.cpp src/manip.cpp src/thememodel.cpp qrc/qml/qml.qrc qrc/img/img.qrc ${HEADERS})

add_dependencies(ikona rust_target)

target_compile_definitions(ikona
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(ikona
  PRIVATE dl pthread 
    Qt5::Core Qt5::Widgets Qt5::Quick Qt5::Concurrent
    KF5::I18n KF5::Kirigami2 KF5::ConfigWidgets PkgConfig::cairo
    PkgConfig::cairo-png PkgConfig::cairo-gobject PkgConfig::fontconfig
    PkgConfig::freetype2 PkgConfig::gdk-pixbuf-2.0 PkgConfig::gio-2.0
    PkgConfig::gio-unix-2.0 PkgConfig::glib-2.0 PkgConfig::gmodule-2.0
    PkgConfig::gthread-2.0 PkgConfig::libxml-2.0 PkgConfig::pangocairo
    PkgConfig::pangoft2 
  ${RUST_LIB})

install(TARGETS ikona DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES ${RUST_LIB} DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(FILES ${RUST_BIN}
        DESTINATION ${CMAKE_INSTALL_BINDIR}
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_WRITE GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
install(FILES ${ZSH_COMPL} DESTINATION ${CMAKE_INSTALL_DATADIR}/zsh/site-functions)
install(FILES ${BASH_COMPL} DESTINATION ${CMAKE_INSTALL_SYSCONFDIR}/bash_completion.d)
install(FILES ${FISH_COMPL} DESTINATION ${CMAKE_INSTALL_DATADIR}/fish/completions)
install(FILES data/org.kde.Ikona.desktop DESTINATION share/applications)
install(FILES data/org.kde.Ikona.svg DESTINATION share/icons/hicolor/scalable/apps)
install(FILES data/org.kde.Ikona.appdata.xml DESTINATION share/metainfo)
