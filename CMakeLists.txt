cmake_minimum_required(VERSION 3.1)

project(kiconviewer LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Quick QuickControls2 REQUIRED)
find_package(KF5Plasma)
find_package(KF5Kirigami2)
find_package(KF5PlasmaQuick)

add_executable(${PROJECT_NAME} "main.cpp" "qml.qrc" "iconsetter.cpp" "iconsetter.h")
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Quick Qt5::QuickControls2 KF5::Kirigami2 KF5::Plasma KF5::PlasmaQuick)

if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set (CMAKE_INSTALL_PREFIX "/usr")
endif()

install(TARGETS kiconviewer DESTINATION bin)
