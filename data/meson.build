install_data('me.appadeia.ikona.desktop', install_dir: join_paths(get_option('prefix'), get_option('datadir'), 'applications'))
install_data('me.appadeia.ikona.svg', install_dir: join_paths(get_option('prefix'), get_option('datadir'), 'icons/hicolor/scalable/apps'))

template_files = ['templates/svg-22-monochrome.desktop',
                  'templates/svg-32-monochrome.desktop',
                  'templates/svg-48-color.desktop',
                  'templates/svg-64-color.desktop',
                  'templates/svg-16-monochrome.desktop',
                  'templates/svg-32-color.desktop',
                  'templates/.source/svg-32-monochrome.svg',
                  'templates/.source/svg-64-color.svg',
                  'templates/.source/svg-48-color.svg',
                  'templates/.source/svg-16-monochrome.svg',
                  'templates/.source/svg-22-monochrome.svg',
                  'templates/.source/svg-32-color.svg']
                  
install_data(template_files, install_dir: join_paths(get_option('prefix'), 'templates'))
