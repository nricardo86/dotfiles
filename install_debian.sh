#!/usr/bin/env bash

#changing debian repo to testing
cat <<EOF | sudo tee /etc/apt/sources.list
deb http://debian.c3sl.ufpr.br/debian testing main contrib non-free non-free-firmware
deb http://debian.c3sl.ufpr.br/debian-security/ testing-security main contrib non-free non-free-firmware
deb http://debian.c3sl.ufpr.br/debian testing-updates main contrib non-free non-free-firmware
EOF

sudo apt update
sudo apt dist-upgrade -y
sudo apt install -y bc eza rsync fontconfig restic pass npm nodejs \
    python3 python3-pip python3-venv gcc zip luarocks curl jq wget git gnupg \
    scdaemon vnstat acpi acpid stow doas htop neovim tmux btop bat ripgrep \
    fish zsh zoxide bash-completion

#config doas
cat <<EOF | sudo tee /etc/doas.conf
permit persist $USER as root
EOF

#adding Ghostty repo
curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
echo "deb https://debian.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list

#adding librewolf repo
! [ -d /etc/apt/keyrings ] && sudo mkdir -p /etc/apt/keyrings && sudo chmod 755 /etc/apt/keyrings

wget -O- https://download.opensuse.org/repositories/home:/bgstack15:/aftermozilla/Debian_Unstable/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/home_bgstack15_aftermozilla.gpg

sudo tee /etc/apt/sources.list.d/home_bgstack15_aftermozilla.sources << EOF > /dev/null
Types: deb
URIs: https://download.opensuse.org/repositories/home:/bgstack15:/aftermozilla/Debian_Unstable/
Suites: /
Signed-By: /etc/apt/keyrings/home_bgstack15_aftermozilla.gpg
EOF

sudo apt update
sudo apt install -y hypr* xdg* fzf bluez zig wlsunset inotify-tools ghostty \
    lazygit network-manager playerctl yazi uv waybar wofi pavucontrol-qt \
    librewolf libreoffice pulseaudio* brightnessctl ddcutil flatpak \
    wireguard wireguard-tools tlp tlp-rdw upower grim swappy
sudo chsh -s $(which fish) $USER

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

#tmux plugin manager install
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#install fonts
mkdir -p ~/.local/share/fonts/
wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip | busybox unzip - -d ~/.local/share/fonts
fc-cache -f

#update default apps
sudo update-alternatives --set editor /usr/bin/nvim
sudo update-alternatives --set x-terminal-emulator /usr/bin/ghostty

mkdir ~/.bkp
mv ~/.{bash*,profile,huslogin,vimrc,ssh,gnupg,zsh*,bin} ~/.bkp/

mkdir -p ~/.{ssh,gnupg,config,zsh,bin,local/bin}

stow --target=$HOME --dotfiles */
