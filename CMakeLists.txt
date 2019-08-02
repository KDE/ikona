cmake_minimum_required(VERSION 3.1)

project(ikona LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Widgets Core Quick QuickControls2 WebEngine REQUIRED)
find_package(KF5Plasma)
find_package(KF5Kirigami2)
find_package(KF5PlasmaQuick)

add_executable(${PROJECT_NAME} "src/main.cpp" "qrc/qml.qrc" "qrc/images.qrc" "src/iconsetter.cpp" "src/iconsetter.h" "src/iconmanipulator.cpp" "src/iconmanipulator.h")
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::WebEngine Qt5::Core Qt5::Quick Qt5::QuickControls2 KF5::Kirigami2 KF5::Plasma KF5::PlasmaQuick)

install(TARGETS ikona DESTINATION bin)
install(FILES data/me.appadeia.ikona.desktop DESTINATION share/applications)
install(FILES data/me.appadeia.ikona.svg DESTINATION share/icons/hicolor/scalable/apps)
install(FILES data/me.appadeia.ikona.appdata.xml DESTINATION share/metainfo)
install(DIRECTORY data/templates DESTINATION share)
