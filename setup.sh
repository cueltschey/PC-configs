#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "This script must be run as root."
	exit 1
fi

for user in $(users); do
	install -D -v --owner $user ./kitty.conf ~/.config/kitty/kitty.conf
	install -D -v --owner $user ./rofi-config.rasi ~/.config/rofi/config.rasi
	install -D -v --owner $user --mode +x ./bar.sh ~/.config/sway/
done

install -D -v --owner root ./config /etc/sway/config

PS4="[INSTALL: general] "
set -x

if [[ -f /etc/os-release ]]; then
	source /etc/os-release
else
	echo "OS could not be determined"
	exit 1
fi

if test "$NAME" = "Ubuntu"; then
	./ubuntu/setup.sh
	./ubuntu/install-nvim.sh
	./ubuntu/update-timezone.sh
fi

set +x
