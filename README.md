# kicon-preview
a shameless ripoff of GNOME Icon Preview, but using KDE's favorite technologies in crap ways

## screenie
![a screenshot of the icon previewer. probably not of much use to you if you're blind and need this.](https://github.com/Appadeia/kicon-preview/blob/master/screen.png?raw=true)

## build dependencies for openSUSE

```
zypper in "cmake(Qt5Core) cmake(Qt5Quick) cmake(Qt5QuickControls2) cmake(KF5Kirigami2)"
```

## installing
too lazy to make a desktop file or a package, so here's how you do it

```
cd $dir_to_this_cloned
mkdir build
cd build
cmake ..
make
```
you'll want to copy the fancy binary to somewhere in your $PATH.  
no desktop file provided.
if you're using this, you're probably using Plasma. krunner can run commands.
