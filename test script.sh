#! /bin/bash
cd ~/.config
wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/chrome-flags.conf
pacman -S --noconfirm qemu-full virt-manager swtpm
echo 'firewall_backend = "iptables"' | tee -a /etc/libvirt/network.conf
usermod -aG libvirt $USER
systemctl enable --now libvirtd.service
systemctl enable --now libvirtd.socket
virsh net-autostart default
ufw route allow from 192.168.122.0/24
cd ~/Desktop
wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/steam_dev.cfg
cd ~/Projects
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
curl -s https://repo.cider.sh/ARCH-GPG-KEY | pacman-key --add -
pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A61682
echo '[cidercollective] | tee -a /etc/pacman.conf
echo 'SigLevel = Required TrustedOnly' | tee -a /etc/pacman.conf
echo 'Server = https://repo.cider.sh/arch' | tee -a /etc/pacman.conf
pacman -Syu --noconfirm flatpak obs-studio-browser amdgpu_top blender calf cava cdrdao cdrtools cider cmake deja-dup discord discover dolphin-plugins dvd+rw-tools dysk easyeffects extra-cmake-modules ffmpeg gimp go handbrake jre-openjdk k3b lsp-plugins-lv2 mda.lv2 ntfs-3g ntfsprogs obsidian okular onlyoffice-bin prismlauncher protonplus proton-pass proton-vpn-gtk-app rpi-imager terminus-font thunderbird transmission-gtk ttf-noto-nerd vlc zam-plugins
yay -S --noconfirm darkly google-chrome kwin-effects-better-blur-dx qdiskinfo twintaillauncher-bin visual-studio-code-bin xivlauncher zoom
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
flatpak install -y flathub io.github.maniacx.BudsLink io.github.wartybix.Constrict com.github.huluti.Curtail com.github.tchx84.Flatseal com.github.tenderowl.frog it.mijorus.gearlever org.jellyfin.JellyfinDesktop com.makemkv.MakeMKV io.github.alainm23.planify com.yubico.yubioauth app.zen_browser.zen
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/EasyEffects-Presets/master/install.sh)"
echo 'FONT=ter-132b' | tee -a /etc/vconsole.conf
curl -fsSL https://raw.githubusercontent.com/jurkovic-nikola/OpenLinkHub/main/remote-install.sh | bash
rm /opt/OpenLinkHub/config.json
cd /opt/OpenLinkHub
wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/config.json
echo 'KERNEL=="i2c-18", MODE="0600", OWNER="openlinkhub" | tee /etc/udev/rules.d/98-corsair-memory.rules
udevadm control --reload-rules
udevadm trigger
systemctl restart OpenLinkHub.service
mkdir /mnt/Share /mnt/oppa
echo '//192.168.1.123/Share /mnt/Share cifs _netdev,nofail,uid=brad,username=badams,password=[],rw 0 0 | tee -a /etc/fstab
cd ~Projects
git clone https://github.com/paulmcauley/klassy
cd klassy
git checkout plasma6.3
./install.sh
cd ~/Projects
git clone https://github.com/badams700/Orchis-kde
cd Orchis-kde/
./install.sh
mkdir ~/.config/fastfetch
cd ~/.config/fastfetch
wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/config.jsonc
cd ~/Projects
wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/blur.kwinrule
cd ~/Projects
wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst
pacman -U ./WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst --overwrite '*'
