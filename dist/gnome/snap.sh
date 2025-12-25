#!/bin/bash
snap remove desktop-security-center
snap remove firefox
snap remove firmware-updater
snap remove gnome-42-2204
snap remove gtk-common-themes
snap remove prompting-client
snap remove snapd-desktop-integration
snap remove snap-store
snap remove core22
snap remove bare
snap remove snapd
sudo systemctl stop snapd
sudo systemctl disable snapd
sudo systemctl mask snapd
sudo apt purge snapd -y
sudo apt-mark hold snapd
sudo cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
rm -rf ~/snap/
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
