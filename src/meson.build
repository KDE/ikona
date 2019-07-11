ikona_sources = ['iconsetter.cpp', 'main.cpp']

ikona = executable('ikona',
                   ikona_sources,
                   processed_files,
                   include_directories: inc,
                   dependencies: [qt5_dep, kf5plasma_dep, kf5plasmaquick_dep, kf5kirigami2_dep],
                   install: true)
