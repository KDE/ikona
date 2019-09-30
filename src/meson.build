ikona_sources = ['iconsetter.cpp', 'main.cpp', 'iconmanipulator.cpp']

ikona = executable('ikona',
                   ikona_sources,
                   processed_files,
                   include_directories: inc,
                   dependencies: [qt5_dep, kf5plasma_dep, kf5plasmaquick_dep, kf5kirigami2_dep, kf5i18n_dep],
                   install: true)
