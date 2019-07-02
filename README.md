# Ikona
A companion utility to help see an icon you are editing. Note: This uses a lot of new Qt things, so this probably won't work on distros with Qt older than 5.12.

## contributors 
- pontos/appadeia: main application design & programming, alongside original icon
- noahdvs: input on application & help with making icon more breezy
- hellcp: input on application design. also name of application.

## screenie
![a screenshot of the icon previewer. probably not of much use to you if you're blind and need this.](https://github.com/Appadeia/ikona/raw/master/screen.png)

## build dependencies for openSUSE

```
zypper in "cmake(Qt5Core) cmake(Qt5Quick) cmake(Qt5WebEngine) cmake(Qt5QuickControls2) cmake(KF5Kirigami2) cmake(KF5Plasma) cmake(KF5PlasmaQuick)"
```

## installing
for when you're not on openSUSE and need to do it yourself

```
cd $dir_to_this_cloned
mkdir build
cd build
cmake ..
make
sudo make install
```

## templates
copy `templates/` and merge with `/usr/share/templates`

## installing desktop file
this lets you right click in your file manager and open directly  
how fun

```
cd $dir_to_this_cloned
sudo cp ikona.desktop /usr/share/applications/
sudo update-desktop-database
```
