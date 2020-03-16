Dependencies for building:
  - CMake:
      - KF5: ConfigWidgets, Kirigami2, Plasma, PlasmaQuick, I18n
      - Qt5: Core, Quick, QuickControls2, Widgets
  - pkgconfg:
      - cairo, cairo-png, fontconfig, freetype2, gdk-pixbuf-2.0, gio-2.0, gio-unix-2.0, glib-2.0, gmodule-2.0, gthread-2.0, libxml-2.0, pangocairo, pangoft2
  - Tools:
      - gcc (or clang), rustc, cargo

Using the cargo vendor tarball:
  Place the tarball in the root of the source, renamed to ikona.cargo.vendor.tar.xz.
  CMake will handle the rest for you.
  
Splitting the package:
  {bindir}/ikona and {libdir}/libikonars.so should absolutely never be split. libikonars is only consumed by ikona, and ikona depends on libikonars.

  {bindir}/ikona-cli can be split freely.