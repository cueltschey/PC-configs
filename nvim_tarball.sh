#!/bin/bash

if [ $EUID -ne 0 ]; then
  echo "must be run as root"
  exit 1
fi

NEOVIM_RELEASE="https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.tar.gz"

wget -O /tmp/nvim-linux-x86_64.tar.gz $NEOVIM_RELEASE

tar -xvf /tmp/nvim-linux-x86_64.tar.gz -C /opt
