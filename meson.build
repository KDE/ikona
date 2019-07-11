project('ikona', 'cpp')

qt5 = import('qt5')
qt5_dep = dependency('qt5', modules: ['Widgets', 'Core', 'Quick', 'QuickControls2', 'WebEngine'])
kde_deps = [dependency('KF5Plasma'),
            dependency('KF5PlasmaQuick'),
            dependency('KF5Kirigami2')]

inc = include_directories('include')

qresource_files = ['qrc/images.qrc', 'qrc/qml.qrc']

processed_files = qt5.preprocess(moc_headers: ['include/iconsetter.h'],
                                 include_directories: inc,
                                 qresources: qresource_files)

subdir('src')
subdir('data')
