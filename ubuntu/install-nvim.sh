# configure nvim
apt install -y curl git
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
rm -rf /opt/nvim
tar -C /opt -xzf nvim-linux64.tar.gz
git clone https://github.com/cueltschey/neovim-config ~/.config/nvim
echo "export PATH=$PATH:/opt/nvim-linux64/bin" >>~/.bashrc
source ~/.bashrc
