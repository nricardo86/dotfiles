#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

cat <<EOF | sudo tee /etc/apt/sources.list
deb http://deb.debian.org/debian testing main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ testing-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian testing-updates main contrib non-free non-free-firmware
deb http://debian.c3sl.ufpr.br/debian/ bookworm-backports main contrib non-free non-free-firmware
deb https://deb.debian.org/debian unstable main contrib non-free-firmware
EOF

sudo apt update
sudo apt dist-upgrade -y
sudo apt install -y i3 i3blocks bc eza deborphan rsync fontconfig autotiling dunst libbz2-dev libsqlite3-dev tk libffi-dev restic pass flameshot npm nodejs python3 python3-pip python3-venv gcc zip luarocks curl jq wget alacritty ranger git gnupg scdaemon vnstat acpi acpid xbanish feh picom xinit stow htop neovim tmux btop bat ripgrep fish zsh zoxide zathura

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
cat <<EOF | sudo tee /etc/apt/sources.list.d/librewolf.sources
Types: deb
URIs: https://deb.librewolf.net
Suites: bookworm
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF

sudo apt update
sudo apt install -y brave-browser librewolf
sudo apt autoremove --purge -y

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/asdf-vm/asdf ~/.asdf

mkdir -p ~/.local/share/fonts/
wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip | busybox unzip - -d ~/.local/share/fonts
fc-cache -f

sudo update-alternatives --set editor /usr/bin/nvim
sudo update-alternatives --set x-terminal-emulator /usr/bin/alacritty

mkdir ~/.bkp
mv ~/.{bash*,profile,huslogin,vimrc,ssh,gnupg,zsh*,bin,wallpaper} ~/.bkp/

mkdir -p ~/.{ssh,gnupg,config,zsh,wallpaper,bin,.local/bin}

stow --target=$HOME --dir=$SCRIPT_DIR --dotfiles */

cat <<EOF | crontab -
$(crontab -l)
@hourly DISPLAY=:0 $HOME/.bin/disp.sh
@hourly DISPLAY=:0 feh --no-fehbg --bg-scale --randomize $HOME/.wallpaper/
*/10 * * * * DISPLAY=:0 $HOME/.bin/xlockidle.sh -t 9
EOF

chsh -s $(which fish)
