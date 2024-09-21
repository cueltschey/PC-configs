# configure nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
git clone https://github.com/LazyVim/starter ~/.config/nvim
echo "export PATH=$PATH:/opt/nvim-linux64/bin" >>~/.bashrc
