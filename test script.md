```
cd ~/.config \
sudo wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/chrome-flags.conf \
sudo pacman -S qemu-full virt-manager swtpm \
echo 'firewall_backend = "iptables"' | sudo tee -a /etc/libvirt/network.conf \
sudo usermod -aG libvirt $USER \
systemctl enable --now libvirtd.service \
systemctl enable --now libvirtd.socket \
sudo virsh net-autostart default \
sudo ufw route allow from 192.168.122.0/24 \
cd ~/Desktop \
sudo wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/steam_dev.cfg \
cd ~/Projects \
git clone https://aur.archlinux.org/yay.git \
cd yay \
makepkg -si \
curl -s https://repo.cider.sh/ARCH-GPG-KEY | sudo pacman-key --add -
sudo pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A61682 \
echo '[cidercollective] | sudo tee -a /etc/pacman.conf \
echo 'SigLevel = Required TrustedOnly' | sudo tee -a /etc/pacman.conf \
echo 'Server = https://repo.cider.sh/arch' | sudo tee -a /etc/pacman.conf \
yay \
sudo pacman -S flatpak obs-studio-browser amdgpu_top blender calf cava cdrdao cdrtools cider cmake deja-dup discord discover dolphin-plugins dvd+rw-tools dysk easyeffects extra-cmake-modules ffmpeg gimp go handbrake jre-openjdk k3b lsp-plugins-lv2 mda.lv2 ntfs-3g ntfsprogs obsidian okular onlyoffice-bin prismlauncher protonplus proton-pass proton-vpn-gtk-app rpi-imager terminus-font thunderbird transmission-gtk ttf-noto-nerd vlc zam-plugins \
yay -S darkly google-chrome kwin-effects-better-blur-dx qdiskinfo twintaillauncher-bin visual-studio-code-bin xivlauncher zoom \
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin \
flatpak install flathub io.github.maniacx.BudsLink io.github.wartybix.Constrict com.github.huluti.Curtail com.github.tchx84.Flatseal com.github.tenderowl.frog it.mijorus.gearlever org.jellyfin.JellyfinDesktop com.makemkv.MakeMKV io.github.alainm23.planify com.yubico.yubioauth app.zen_browser.zen \
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/EasyEffects-Presets/master/install.sh)" \
echo 'FONT=ter-132b' | sudo tee -a /etc/vconsole.conf \
curl -fsSL https://raw.githubusercontent.com/jurkovic-nikola/OpenLinkHub/main/remote-install.sh | bash \
sudo rm /opt/OpenLinkHub/config.json \
cd /opt/OpenLinkHub \
sudo wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/config.json \
echo 'KERNEL=="i2c-18", MODE="0600", OWNER="openlinkhub" | sudo tee /etc/udev/rules.d/98-corsair-memory.rules \
sudo udevadm control --reload-rules \
sudo udevadm trigger \
sudo systemctl restart OpenLinkHub.service \ 
sudo mkdir /mnt/Share /mnt/oppa \
echo '//192.168.1.123/Share /mnt/Share cifs _netdev,nofail,uid=brad,username=badams,password=[],rw 0 0 | sudo tee -a /etc/fstab \
cd ~Projects \
git clone https://github.com/paulmcauley/klassy \
cd klassy \
git checkout plasma6.3 \
./install.sh \
cd ~/Projects \
git clone https://github.com/badams700/Orchis-kde \
cd Orchis-kde/ \
./install.sh \
mkdir ~/.config/fastfetch \
cd ~/.config/fastfetch \
wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/config.jsonc \
cd ~/Projects \
wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/blur.kwinrule \
cd ~/Projects \
sudo wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst \
sudo pacman -U ./WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst --overwrite '*'
```
