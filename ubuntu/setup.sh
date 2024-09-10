sudo apt update && upgrade -y

# Setup foot sway and rofi
mkdir -pv ~/.config/foot ~/.config/sway ~/.config/rofi/
cp ./foot.ini ~/.config/foot/foot.ini
sudo cp ./config /etc/sway/config
cp ./rofi-config.rasi ~/.config/rofi/config.rasi

swaymsg reload

sudo apt install -y swaybg swayidle swaylock waybar grimshot rofi

# Install all the necessary tools
sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
	sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
	sudo apt update &&
	sudo apt install gh -y
sudo apt install -y make gcc snap cmake binutils bison gawk texinfo

# configure nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
git clone https://github.com/LazyVim/starter ~/.config/nvim

# install nice things
sudo apt install -y chromium-browser

gh auth login
gh extension install https://github.com/sarumaj/gh-gr
gh extension install wuwe1/gh-ls
gh extension install Link-/gh-token
gh extension install gennaro-tedesco/gh-s
