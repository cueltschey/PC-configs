#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "This script must be run as root."
	exit 1
fi

PS4="INSTALL: Arch >"
set -x

pacman -Syu

# Install sway related packages
pacman -S --noconfirm swaybg swayidle swaylock waybar \
	make gcc cmake binutils tldr github-cli foot rofi \
	chromium curl git

gh extension install wuwe1/gh-ls
