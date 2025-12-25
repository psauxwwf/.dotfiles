#!/bin/bash

user="$USER"

sudo chown -R "$user:$user" /usr/local/bin

sudo apt update --yes
sudo apt upgrade --yes
sudo apt-get install gnome-tweaks gnome-shell-extension-manager gnome-shell-extensions dconf-editor curl \
	remmina remmina-plugin-rdp remmina-plugin-secret remmina-plugin-spice zsh \
	qt6-style-kvantum qt5ct qt6ct

sudo add-apt-repository ppa:mozillateam/ppa
sudo apt update
sudo apt-get install firefox-esr

wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.10.6/obsidian_1.10.6_amd64.deb
sudo apt-get install ./obsidian_1.10.6_amd64.deb
rm -f obsidian_1.10.6_amd64.deb

sudo add-apt-repository ppa:phoerious/keepassxc
sudo apt update
sudo apt install keepassxc

wget https://github.com/ungoogled-software/ungoogled-chromium-portablelinux/releases/download/143.0.7499.169-1/ungoogled-chromium-143.0.7499.169-1-x86_64_linux.tar.xz

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/bin/kitty /usr/local/bin/kitty

curl https://mise.run | sh
mv .local/bin/mise /usr/local/bin/

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
