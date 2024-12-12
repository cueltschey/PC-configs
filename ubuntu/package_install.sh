#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "This script must be run as root."
	exit 1
fi

PS4="INSTALL: Ubuntu> "
set -x


apt update && apt upgrade -y

# Install sway related packages
apt install -y curl git
apt install -y swaybg swayidle swaylock waybar grimshot rofi foot
swaymsg reload

# Install gh cli
mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
	chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
	apt update &&
	apt install gh -y

# Install build tools
apt install -y make gcc snap cmake binutils tldr

# install browser
apt install -y chromium-browser

gh extension install wuwe1/gh-ls
