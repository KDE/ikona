cmake_minimum_required(VERSION 3.5)

project(ikona LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)

find_package(Qt5 COMPONENTS Core Widgets Quick REQUIRED)
find_package(KF5Kirigami2)
find_package(KF5ConfigWidgets)
find_package(KF5I18n)

# rust

string(TOUPPER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_UPPER)
if(CMAKE_BUILD_TYPE_UPPER STREQUAL DEBUG)
    set(RUST_TARGET_DIR target/debug/)
    set(RUST_BUILD_FLAG)
else()
    set(RUST_TARGET_DIR target/release/)
    set(RUST_BUILD_FLAG --release)
endif()

SET(RUST_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/rs")
SET(RUST_LIB "${RUST_DIR}/${RUST_TARGET_DIR}/libikonars.so")

find_program(Cargo NAMES cargo)

add_custom_command(
  OUTPUT "${RUST_LIB}"
  COMMAND ${Cargo} build ${RUST_BUILD_FLAG}
  DEPENDS src/rs/src/ikona/ikona.rs src/rs/src/capi/capi.rs
  WORKING_DIRECTORY "${RUST_DIR}"
)

add_custom_target(rust_target DEPENDS "${RUST_LIB}")

# end rust

FILE(GLOB_RECURSE HEADERS "include/*.h")

include_directories(include)

add_executable(ikona src/main.cpp src/manager.cpp src/icon.cpp src/manip.cpp qrc/qml/qml.qrc qrc/img/img.qrc ${HEADERS})

add_dependencies(ikona rust_target)

target_compile_definitions(ikona
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(ikona
  PRIVATE Qt5::Core Qt5::Widgets Qt5::Quick KF5::I18n KF5::Kirigami2 KF5::ConfigWidgets ${RUST_LIB})

install(TARGETS ikona DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES ${RUST_LIB} DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(FILES data/org.kde.Ikona.desktop DESTINATION share/applications)
install(FILES data/org.kde.Ikona.svg DESTINATION share/icons/hicolor/scalable/apps)
install(FILES data/org.kde.Ikona.appdata.xml DESTINATION share/metainfo)
