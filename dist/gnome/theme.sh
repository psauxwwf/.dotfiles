#!/bin/bash

wget https://github.com/dracula/gtk/archive/master.zip
unzip master.zip
mv gtk-master/ Dracula
sudo mv Dracula /usr/share/themes/
rm master.zip

wget https://github.com/dracula/gtk/files/5214870/Dracula.zip
unzip Dracula.zip
sudo mv Dracula /usr/share/icons/
rm Dracula.zip

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip
mkdir CascadiaCode
unzip CascadiaCode.zip -d CascadiaCode
sudo mv CascadiaCode /usr/share/fonts
fc-cache -fv
rm CascadiaCode.zip

gsettings set org.gnome.desktop.wm.preferences button-layout ':'

wget https://github.com/hardpixel/unite-shell/releases/download/v84/unite-v84.zip
gnome-extensions install --force unite-v84.zip
