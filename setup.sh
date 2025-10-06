#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "This script must be run as root."
	exit 1
fi

for user in $(users); do
	user_home=$(getent passwd $user | cut -d: -f6)
	install -D -v --owner $user ./foot.ini $user_home/.config/foot/foot.ini
	install -D -v --owner $user ./config.rasi $user_home/config/rofi/config.rasi
	install -D -v --owner $user --mode +x ./bar.sh $user_home/.config/sway/
	rm -rf $user_home/.config/nvim
	git clone https://github.com/cueltschey/neovim-config $user_home/.config/nvim
	echo "export PATH=$PATH:/opt/nvim-linux64/bin" >>$user_home/.bashrc
done

install -D -v --owner root ./config /etc/sway/config

PS4="INSTALL: general> "
set -x

if [[ -f /etc/os-release ]]; then
	source /etc/os-release
else
	echo "OS could not be determined"
	exit 1
fi

if [ "$NAME" = "Ubuntu" ]; then
	./ubuntu/package_install.sh
fi

if [ "$NAME" = "Arch Linux" ]; then
	./arch/package_install.sh
fi

#timedatectl set-timezone $(curl https://ipinfo.io | jq -r '.timezone')

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
rm -rf /opt/nvim
tar -C /opt -xzf nvim-linux64.tar.gz
set +x
