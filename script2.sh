#!/bin/bash

echo "Running setup script 2."
sleep 5

echo "Configuring pacman repositories..."
sleep 5
# Cider Repo
curl -s https://repo.cider.sh/ARCH-GPG-KEY | pacman-key --add -
pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A61682
echo '[cidercollective]' | tee -a /etc/pacman.conf
echo 'SigLevel = Required TrustedOnly' | tee -a /etc/pacman.conf
echo 'Server = https://repo.cider.sh/arch' | tee -a /etc/pacman.conf

echo "Installing software..."
sleep 5
#Install Programs
pacman -Syu --needed --noconfirm flatpak obs-studio-browser amdgpu_top blender calibre cava cdrdao cdrtools cider cmake deja-dup discord discover dolphin-plugins dvd+rw-tools dysk extra-cmake-modules ffmpeg gimp git go handbrake jre-openjdk k3b npm ntfs-3g ntfsprogs obsidian okular onlyoffice-bin openssh prismlauncher protonplus proton-pass proton-vpn-gtk-app rpi-imager terminus-font thunderbird transmission-gtk ttf-noto-nerd vlc
yay -S --needed --noconfirm darkly google-chrome kwin-effects-better-blur-dx qdiskinfo twintaillauncher-bin visual-studio-code-bin xivlauncher zoom
flatpak install -y flathub io.github.maniacx.BudsLink io.github.wartybix.Constrict com.github.huluti.Curtail com.github.tchx84.Flatseal com.github.tenderowl.frog it.mijorus.gearlever org.jellyfin.JellyfinDesktop com.makemkv.MakeMKV io.github.alainm23.planify com.yubico.yubioath app.zen_browser.zen
echo 'FONT=ter-132b' | sudo tee -a /etc/vconsole.conf

# OpenLinkHub
cd ~/Projects
git clone https://github.com/jurkovic-nikola/OpenLinkHub.git
cd OpenLinkHub/
CGO_CFLAGS_ALLOW='-fno-strict-overflow' go build .
chmod +x install.sh
./install.sh
rm /opt/OpenLinkHub/config.json
cp ~/Projects/linux-setup/Files/config.json /opt/OpenLinkHub
echo 'KERNEL=="i2c-18", MODE="0600", OWNER="openlinkhub"' | tee /etc/udev/rules.d/98-corsair-memory.rules
udevadm control --reload-rules
udevadm trigger
systemctl restart OpenLinkHub.service

echo "Configuring Samba mount..."
sleep 5
# Automount Network Share
mkdir /mnt/Share /mnt/oppa
echo '//192.168.1.123/Share /mnt/Share cifs _netdev,nofail,uid=brad,username=badams,password=*password*,rw 0 0' | tee -a /etc/fstab

echo "Configuring themes and layouts..."
sleep 5
# Cosmetic
cd ~/Projects
git clone https://github.com/paulmcauley/klassy
cd klassy
git checkout plasma6.3
./install.sh
cd ~/Projects/linux-setup/Files
pacman -U ./WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst --overwrite '*'
cd ~/Projects
git clone https://github.com/badams700/Orchis-kde
cd Orchis-kde/
./install.sh
mkdir ~/.config/fastfetch
cp ~/Projects/linux-setup/Files/config.jsonc ~/.config/fastfetch

echo "Setup complete! Move the steam_dev.cfg file to ~/.local/share/Steam once installed. Import the kwin blur effects via System Settings."
read -r -p "Press Enter to exit."
exit
