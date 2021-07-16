<img src="https://github.com/vinceliuice/Sierra-gtk-theme/blob/imgs/logo.png" alt="Logo" align="right" /> WhiteSur Icon Theme
======

MacOS Big Sur like icon theme for linux desktops

## Install tips

Usage:  `./install.sh`  **[OPTIONS...]**

|  OPTIONS:           | |
|:--------------------|:-------------|
|-d, --dest           | Specify theme destination directory (Default: $HOME/.themes)|
|-n, --name           | Specify theme name (Default: WhiteSur)|
|-t, --theme          | Specify theme color variant(s) [default/purple/pink/red/orange/yellow/green/grey/all] (Default: blue)|
|-a, --alternative    | Install alternative icons for software center and file-manager|
|-b, --bold           | Install bold panel icons version|
|-h, --help           | Show this help|

> **Note for snaps:** To use these icons with snaps, the best way is to make a copy of the application's .desktop located in `/var/lib/snapd/desktop/applications/name-of-the-snap-application.desktop` into `$HOME/.local/share/applications/`. Then use any text editor and change the "Icon=" to "Icon=name-of-the-icon.svg"

> For more information, run: `./install.sh --help`

![1](bold-size.png?raw=true)

> Bold version suggested use in `High resolution display` like 4k display with 200% scale!

## Requirment
You can use this with:

### GTK theme

WhiteSur-gtk-theme: https://github.com/vinceliuice/WhiteSur-gtk-theme

### KDE theme

WhiteSur-kde: https://github.com/vinceliuice/WhiteSur-kde

## Preview
![1](preview.png)
![2](preview01.png)
