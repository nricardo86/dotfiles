#!/usr/bin/env bash

#changing debian repo to stable
sudo rm /etc/apt/sources.list
cat <<EOF | sudo tee /etc/apt/sources.list.d/debian.sources
Types: deb
URIs: https://debian.c3sl.ufpr.br/debian/
Suites: testing
Components: main  contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb-src
URIs: https://debian.c3sl.ufpr.br/debian/
Suites: testing
Components: main  contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: https://debian.c3sl.ufpr.br/debian/
Suites: testing-updates
Components: main  contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: https://security.debian.org/debian-security/
Suites: testing-security
Components: main  contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF

sudo apt update
sudo apt dist-upgrade -y
sudo apt install -y bc eza rsync fontconfig restic pass npm nodejs \
    python3 python3-pip python3-venv gcc zip luarocks curl jq wget git gnupg \
    scdaemon vnstat acpi acpid stow doas htop neovim tmux btop bat ripgrep \
    fish zsh zoxide bash-completion smartmontools

#config doas
cat <<EOF | sudo tee /etc/doas.conf
permit persist $USER as root
EOF

#adding Ghostty repo
curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
cat <<EOF | sudo tee /etc/apt/sources.list.d/debian.griffo.io.sources
Types: deb
URIs: https://debian.griffo.io/apt/
Suites: forky
Components: main
Signed-By: /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
EOF

sudo apt update
sudo apt upgrade -y

# install dependencies
sudo apt install -fy build-essential cmake cmake-extras curl findutils \
    gawk gettext gir1.2-graphene-1.0 git glslang-tools gobject-introspection \
    golang hwdata jq libavcodec-dev libavformat-dev libavutil-dev \
    libcairo2-dev libdeflate-dev libdisplay-info-dev libdrm-dev libegl-dev \
    libegl1-mesa-dev libgbm-dev libgdk-pixbuf-2.0-dev libgdk-pixbuf2.0-bin \
    libgirepository1.0-dev libgl1-mesa-dev libgraphene-1.0-0 \
    libgraphene-1.0-dev libgtk-3-dev libgulkan-0.15-0t64 libgulkan-dev \
    libinih-dev libiniparser-dev libinput-dev libjbig-dev libjpeg-dev \
    libjpeg62-turbo-dev liblerc-dev libliftoff-dev liblzma-dev libnotify-bin \
    libpam0g-dev libpango1.0-dev libpipewire-0.3-dev libqt6svg6 \
    libsdbus-c++-dev libseat-dev libstartup-notification0-dev 
sudo apt install -fy libswresample-dev libsystemd-dev libtiff-dev libtiffxx6 \
    libtomlplusplus-dev libudev-dev libvkfft-dev libvulkan-dev \
    libvulkan-volk-dev libwayland-dev libwebp-dev libxcb-composite0-dev \
    libxcb-cursor-dev libxcb-dri3-dev libxcb-ewmh-dev libxcb-icccm4-dev \
    libxcb-present-dev libxcb-render-util0-dev libxcb-res0-dev libxcb-util-dev \
    libxcb-xinerama0-dev libxcb-xinput-dev libxcb-xkb-dev libxkbcommon-dev \
    libxkbcommon-x11-dev libxkbregistry-dev libxml2-dev libxxhash-dev
sudo apt install -fy meson ninja-build openssl psmisc python3-mako \
    python3-markdown python3-markupsafe python3-pyquery python3-yaml \
    qt6-base-dev scdoc seatd spirv-tools unzip vulkan-utility-libraries-dev \
    vulkan-validationlayers wayland-protocols xdg-desktop-portal xwayland \
    liblua5.2-0 libmujs3 libsixel1 libva-wayland2 libxpresent1 yt-dlp \
    gir1.2-gtklayershell-0.1 python3-i3ipc xcur2png
sudo apt install -fy bc binutils libc6 libcairo2-dev libdisplay-info3 libdrm2 \
    libjpeg-dev libjxl-dev libmagic-dev libmuparser-dev libpixman-1-dev \
    libpugixml-dev libre2-dev librsvg2-dev libspng-dev libtomlplusplus-dev \
    libwebp-dev libzip-dev libpam0g-dev libxcursor-dev qt6-declarative-dev \
    qt6-base-private-dev qt6-wayland-dev qt6-wayland-private-dev
sudo apt install -fy libdw1t64 usb.ids i2c-tools libarchive13t64 libmalcontent-0-0 \
    libostree-1-1 libinotifytools0 libbluetooth3 libmm-glib0 libndp0 libnm0 \
    libteamdctl0 python3-pyqt5 python3-dbus.mainloop.pyqt5 python3-dbus \
    libbluetooth3 liblirc-client0t64 avahi-daemon hdparm iw \
    ethtool libsmartcols1 libavahi-core7 libdaemon0 python3-pyqt5.sip \
    libqt5core5t64 libqt5dbus5t64 libqt5designer5 \
    libqt5network5t64 libqt5printsupport5t64 libqt5test5t64 libqt5widgets5t64 \
    libmm-glib0 libqt5xml5t64 libxcb-xinerama0 libqt5help5 
# install apps
sudo apt install -fy xdg-dbus-proxy xdg-desktop-portal-hyprland fzf bluez \
    hyprland hyprcursor-util hypridle hyprland-protocols hyprland-qtutils \
    hyprlock hyprpaper hyprpicker hyprwayland-scanner hyprland-backgrounds \
    zig wlsunset inotify-tools ghostty lazygit network-manager playerctl yazi \
    uv waybar wofi pavucontrol-qt libreoffice pulseaudio \
    pulseaudio-module-bluetooth pulseaudio-utils firefox-esr chromium \
    fonts-stix fonts-lmodern libreoffice-gtk3 \
    libreoffice-style-breeze brightnessctl ddcutil flatpak rfkill wireguard \
    wireguard-tools tlp tlp-rdw tlp-pd upower grim swappy qt5ct qt6ct yad \
    xdg-utils mpv pamixer nvtop nwg-look nwg-displays adwaita-icon-theme \
    adwaita-qt adwaita-qt6 cups

#set fish shell default for current user
sudo chsh -s $(which fish) $USER

#install nodejs neovim plugin
sudo npm -g install neovim

#config python pip manager
python3 -m pip config set global.break-system-packages true

#add flathub remotes to flatpak
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

#backup current files 
mkdir ~/.bkp
mv ~/.{bash*,profile,huslogin,vimrc,ssh,gnupg,zsh*,bin} ~/.bkp/
mkdir -p ~/.{ssh,gnupg,config,zsh,bin,local/bin}

#stage files 
stow --target=$HOME --dotfiles */
