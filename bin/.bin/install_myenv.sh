#!/usr/bin/env bash

RELEASE=$(lsb_release -c | tail -n1 | cut -d":" -f2 | xargs)
sed "s/$RELEASE/testing" /etc/apt/sources.list | tee /etc/apt/sources.list

apt update
apt install -y \ 
    i3 i3blocks dunst curl wget alacritty ranger \ 
    git gnupg xbanish feh picom xinit stow htop \ 
    nvim tmux btop batcat ripgrep fish zoxide zathura

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \ 
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] 
    https://brave-browser-apt-release.s3.brave.com/ stable main" \ 
        | tee /etc/apt/sources.list.d/brave-browser-release.list
apt update
apt install brave-browser


mkdir -p ~/.local/share/fonts/
wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip | busybox unzip - -d ~/.local/share/fonts
fc-cache -f
