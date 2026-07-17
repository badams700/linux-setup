#!/bin/bash
set -e

# This script must run as root (for pacman.conf edits, systemd, udev, fstab,
# etc.) but builds AUR packages as an unprivileged user. Set TARGET_USER
# below rather than relying on $HOME/$USER, which are root's when run via sudo.
TARGET_USER="brad"
TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)

# -- Yay --
echo "Installing Yay AUR Helper."
sleep 3
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/Projects"
cd "$TARGET_HOME/Projects"
sudo -u "$TARGET_USER" git clone https://aur.archlinux.org/yay.git
cd yay
sudo -u "$TARGET_USER" makepkg -si --noconfirm

# -- Repos --
echo "Configuring Repos..."
sleep 5
curl -s https://repo.cider.sh/ARCH-GPG-KEY | pacman-key --add -
# NOTE: verify this fingerprint against repo.cider.sh before running --
# the original had 41 hex chars (one too many for a valid fingerprint).
pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A6168
echo '[cidercollective]' | tee -a /etc/pacman.conf
echo 'SigLevel = Required TrustedOnly' | tee -a /etc/pacman.conf
echo 'Server = https://repo.cider.sh/arch' | tee -a /etc/pacman.conf

# -- Packages --
echo "Installing Packages..."
sleep 3
sudo -u "$TARGET_USER" yay -Syu --needed --noconfirm blender calibre cava cdrdao cdrtools cider cmake deja-dup discord discover dolphin-plugins dvd+rw-tools dysk extra-cmake-modules ffmpeg flatpak gimp git go handbrake jre-openjdk k3b npm ntfs-3g ntfsprogs obs-studio-browser obsidian okular onlyoffice-bin openssh prismlauncher protonplus proton-pass proton-vpn-gtk-app rpi-imager terminus-font thunderbird transmission-gtk ttf-noto-nerd vlc darkly google-chrome kwin-effects-better-blur-dx qdiskinfo twintaillauncher-bin visual-studio-code-bin xivlauncher zoom
flatpak install -y flathub io.github.maniacx.BudsLink io.github.wartybix.Constrict com.github.huluti.Curtail com.github.tchx84.Flatseal com.github.tenderowl.frog it.mijorus.gearlever org.jellyfin.JellyfinDesktop com.makemkv.MakeMKV io.github.alainm23.planify com.yubico.yubioath app.zen_browser.zen org.vinegarhq.Sober

# -- OpenLinkHub --
echo "Installing Corsair Support..."
sleep 3
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/Projects"
cd "$TARGET_HOME/Projects"
sudo -u "$TARGET_USER" git clone https://github.com/jurkovic-nikola/OpenLinkHub.git
cd OpenLinkHub/
CGO_CFLAGS_ALLOW='-fno-strict-overflow' go build .
chmod +x install.sh
./install.sh
sleep 3
rm -f /opt/OpenLinkHub/config.json
wget -P /opt/OpenLinkHub https://raw.githubusercontent.com/badams700/linux-setup/main/Files/config.json
echo 'KERNEL=="i2c-11", MODE="0600", OWNER="openlinkhub"' | tee /etc/udev/rules.d/98-corsair-memory.rules
udevadm control --reload-rules
udevadm trigger
systemctl restart OpenLinkHub.service

# -- Samba --
echo "Configuring Samba Share..."
sleep 3
read -s -p "Enter the password for the Samba Share: " password
echo ""
creds_file="/root/.smbcredentials"
{
    echo "username=badams"
    echo "password=$password"
} > "$creds_file"
chmod 600 "$creds_file"
mkdir -p /mnt/Share /mnt/oppa
line="//192.168.1.123/Share /mnt/Share cifs _netdev,nofail,uid=$TARGET_USER,credentials=$creds_file,rw 0 0"
if ! grep -qs "/mnt/Share" /etc/fstab; then
    echo "$line" | tee -a /etc/fstab
    echo "Added to fstab."
else
    echo "Mount already exists in fstab."
fi

# -- Customization --
echo "Configuring KDE Customizations..."
sleep 3
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/.config/fastfetch"
sudo -u "$TARGET_USER" wget -P "$TARGET_HOME/.config/fastfetch" https://raw.githubusercontent.com/badams700/linux-setup/main/Files/config.jsonc
echo "Fastfetch Configuration Saved."
sleep 3
echo 'FONT=ter-132b' | tee -a /etc/vconsole.conf

echo "Installing Klassy..."
sleep 3
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/Projects"
cd "$TARGET_HOME/Projects"
sudo -u "$TARGET_USER" git clone https://github.com/paulmcauley/klassy
cd klassy
sudo -u "$TARGET_USER" git checkout plasma6.3
./install.sh
sleep 1

echo "Installing Orchis..."
sleep 1
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/Projects"
cd "$TARGET_HOME/Projects"
sudo -u "$TARGET_USER" git clone https://github.com/badams700/Orchis-kde
cd Orchis-kde/
./install.sh
sleep 1

echo "Installing Wallpaper Engine..."
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/Projects"
cd "$TARGET_HOME/Projects"
sudo -u "$TARGET_USER" wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst
pacman -U ./WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst --overwrite '*'
sleep 1

echo "Configuring Window Blur Config..."
[ -f "$TARGET_HOME/.config/kwinrulesrc" ] && rm "$TARGET_HOME/.config/kwinrulesrc"
sudo -u "$TARGET_USER" wget -P "$TARGET_HOME/.config" https://raw.githubusercontent.com/badams700/linux-setup/main/Files/kwinrulesrc

echo "Configuration Complete."
read -p "Press [Enter] to exit."
exit 0
