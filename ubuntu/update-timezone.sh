#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "This script must be run as root."
	exit 1
fi

timedatectl set-timezone $(curl https://ipinfo.io | jq -r '.time
zone')
