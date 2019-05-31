# kicon-preview
a shameless ripoff of GNOME Icon Preview, but using KDE's favorite technologies in crap ways

## screenie
![a screenshot of the icon previewer. probably not of much use to you if you're blind and need this.](https://github.com/Appadeia/kicon-preview/blob/master/screen.png?raw=true)

## build dependencies for openSUSE

```
zypper in "cmake(Qt5Core) cmake(Qt5Quick) cmake(Qt5QuickControls2) cmake(KF5Kirigami2)"
```

## installing
too lazy to package, here's how you do it yourself

```
cd $dir_to_this_cloned
mkdir build
cd build
cmake ..
make
sudo make install
```

## installing desktop file
this lets you right click in your file manager and open directly  
how fun

```
cd $dir_to_this_cloned
sudo cp iconviewer.desktop /usr/share/applications/
sudo update-desktop-database
```
