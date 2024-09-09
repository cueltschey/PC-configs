apt update && upgrade -y

# Setup foot sway and rofi
mkdir -pv ~/.config/foot ~/.config/sway ~/.config/rofi/
cp ./foot.ini ~/.config/foot/foot.ini
cp ./config /etc/sway/config
cp ./rofi-config.rasi ~/.config/rofi/config.rasi

swaymsg reload

apt install swaybg swayidle swaylock waybar grimshot rofi

# Install all the necessary tools
./get_gh.sh
apt install make gcc snap cmake binutils bison gawk texinfo

# configure nvim
snap install nvim --classic
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
cat <EOF >>~/.bashrc
export PATH="$PATH:/opt/nvim-linux64/bin"
EOF

git clone https://github.com/LazyVim/starter ~/.config/nvim

# install nice things
sudo apt install chromium-browser
gh extension install wuwe1/gh-ls
gh auth login
