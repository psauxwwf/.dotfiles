#!/usr/bin/env bash
set -euo pipefail

PACKAGES=(
	baobab
	com.github.donadigo.eddy
	geary
	gedit
	gnome-calendar
	gnome-characters
	gnome-clocks
	gnome-contacts
	gnome-disk-utility
	gnome-font-viewer
	gnome-logs
	gnome-system-monitor
	gnome-user-docs
	gnome-weather
	gucharmap
	pop-shop
	seahorse
	simple-scan
	totem
	yelp
	decibels
	gnome-maps
	gnome-boxes
	showtime
	gnome-tour
	mediawriter
	gnome-connections
	podman
	"cockpit*"
)

if [[ "${EUID}" -eq 0 ]]; then
	SUDO=()
else
	SUDO=(sudo)
fi

if command -v apt-get >/dev/null 2>&1; then
	"${SUDO[@]}" apt-get autoremove --purge -y "${PACKAGES[@]}"
	"${SUDO[@]}" apt-get autoremove --purge -y
	"${SUDO[@]}" apt-get autoclean
elif command -v dnf >/dev/null 2>&1; then
	"${SUDO[@]}" dnf remove -y "${PACKAGES[@]}"
	"${SUDO[@]}" dnf autoremove -y
else
	echo "No supported package manager found (apt-get or dnf)." >&2
	exit 1
fi
