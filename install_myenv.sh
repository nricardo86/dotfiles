#!/usr/bin/env bash

cat <<EOF | sudo tee /etc/apt/sources.list
deb http://deb.debian.org/debian testing main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ testing-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian testing-updates main contrib non-free non-free-firmware
deb http://debian.c3sl.ufpr.br/debian/ bookworm-backports main contrib non-free non-free-firmware
deb https://deb.debian.org/debian unstable main contrib non-free-firmware
EOF

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt dist-upgrade -y
sudo apt install -y i3 i3blocks eza fontconfig dunst nodejs npm python3-pip python3-venv gcc zip luarocks curl jq wget alacritty ranger git gnupg pcscd vnstat acpi acpid xbanish feh picom xinit stow htop neovim tmux btop bat ripgrep fish zoxide zathura

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
sudo apt update
sudo apt install -y brave-browser
sudo apt autoremove --purge -y

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/asdf-vm/asdf ~/.asdf

mkdir -p ~/.local/share/fonts/
wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip | busybox unzip - -d ~/.local/share/fonts
fc-cache -f

sudo update-alternatives --set editor /usr/bin/nvim
sudo update-alternatives --set x-terminal-emulator /usr/bin/alacritty

stow --target=$HOME --dir=$HOME/dotfiles */
