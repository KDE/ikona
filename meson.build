project('ikona', 'cpp')

qt5 = import('qt5')
qt5_dep = dependency('qt5', modules: ['Widgets', 'Core', 'Quick', 'QuickControls2', 'WebEngine'])
kf5plasma_dep = dependency('KF5Plasma')
kf5plasmaquick_dep = dependency('KF5PlasmaQuick')
kf5kirigami2_dep = dependency('KF5Kirigami2')

inc = include_directories('src')

qresource_files = ['qrc/images.qrc', 'qrc/qml.qrc']

processed_files = qt5.preprocess(moc_headers: ['src/iconsetter.h', 'src/iconmanipulator.h'],
                                 include_directories: inc,
                                 qresources: qresource_files)

subdir('src')
subdir('data')
