sudo apt update && sudo apt upgrade -y

# Install sway related packages
sudo apt install -y swaybg swayidle swaylock waybar grimshot rofi kitty

# Setup foot sway and rofi
mkdir -pv ~/.config/kitty ~/.config/sway ~/.config/rofi/
cp ./kitty.conf ~/.config/kitty/kitty.conf
sudo cp ./config /etc/sway/config
cp ./rofi-config.rasi ~/.config/rofi/config.rasi

swaymsg reload

# Install gh cli
sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
	sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
	sudo apt update &&
	sudo apt install gh -y

# Install build tools
sudo apt install -y make gcc snap cmake binutils bison gawk texinfo

./ubuntu/install-nvim.sh

# install browser
sudo apt install -y chromium-browser

gh auth login
gh extension install https://github.com/sarumaj/gh-gr
gh extension install wuwe1/gh-ls
