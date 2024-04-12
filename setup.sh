sudo apt update && upgrade -y

# Setup foot sway and rofi
mkdir -pv ~/.config/foot ~/.config/sway ~/.config/rofi/
cp ./foot.ini ~/.config/foot/foot.ini
sudo cp ./sway_config /etc/sway/config
cp ./rofi-config.rasi ~/.config/rofi/config.rasi

swaymsg reload

apt install swaybg swayidle swaylock waybar

# Install all the necessary tools
./get_gh.sh
apt install make gcc snap cmake binutils bison gawk texinfo

# configure nvim
snap install nvim --classic
git clone https://github.com/LazyVim/starter ~/.config/nvim

# install nice things
sudo apt install chromium-browser qutebrowser

gh auth login
