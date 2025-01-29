#!/usr/bin/env bash

cat <<EOF | sudo tee /etc/apt/sources.list
deb http://deb.debian.org/debian testing main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ testing-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian testing-updates main contrib non-free non-free-firmware
deb http://debian.c3sl.ufpr.br/debian/ bookworm-backports main contrib non-free non-free-firmware
deb https://deb.debian.org/debian unstable main contrib non-free-firmware
EOF

sudo apt update
sudo apt dist-upgrade -y
sudo apt install -y bc eza deborphan rsync fontconfig restic pass npm nodejs \
    python3 python3-pip python3-venv gcc zip luarocks curl jq wget git gnupg \
    scdaemon vnstat acpi acpid stow htop neovim tmux btop bat ripgrep fish zsh zoxide

sudo apt update

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/asdf-vm/asdf ~/.asdf

mkdir -p ~/.local/share/fonts/
wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip | busybox unzip - -d ~/.local/share/fonts
fc-cache -f

sudo update-alternatives --set editor /usr/bin/nvim
sudo update-alternatives --set x-terminal-emulator /usr/bin/alacritty

mkdir ~/.bkp
mv ~/.{bash*,profile,huslogin,vimrc,ssh,gnupg,zsh*,bin} ~/.bkp/

mkdir -p ~/.{ssh,gnupg,config,zsh,bin,.local/bin}

stow --target=$HOME --dir=$SCRIPT_DIR --dotfiles */

chsh -s $(which fish)
