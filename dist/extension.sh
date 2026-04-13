#!/bin/bash
./gnome-extension-web-install apps-menu@gnome-shell-extensions.gcampax.github.com
./gnome-extension-web-install auto-move-windows@gnome-shell-extensions.gcampax.github.com
./gnome-extension-web-install background-logo@fedorahosted.org
./gnome-extension-web-install blur-my-shell@aunetx
./gnome-extension-web-install forge@jmmaranan.com
./gnome-extension-web-install hidetopbar@mathieu.bidon.ca
./gnome-extension-web-install just-perfection-desktop@just-perfection
./gnome-extension-web-install launch-new-instance@gnome-shell-extensions.gcampax.github.com
./gnome-extension-web-install lock-guard@fthx
./gnome-extension-web-install places-menu@gnome-shell-extensions.gcampax.github.com
./gnome-extension-web-install rounded-window-corners@fxgn
# ./gnome-extension-web-install space-bar@luchrioh
./gnome-extension-web-install unite@hardpixel.eu
./gnome-extension-web-install user-theme@gnome-shell-extensions.gcampax.github.com
./gnome-extension-web-install window-list@gnome-shell-extensions.gcampax.github.com
# ./gnome-extension-web-install window-title-is-back@fthx
# ./gnome-extension-web-install tiling-assistant@leleat-on-github

gnome-extensions install -f rounded-window-corners@fxgn.shell-extension.zip

sudo dnf install gnome-shell-extension-pop-shell
python3 pop-shell-patch.py
