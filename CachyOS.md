# Time
```
timedatectl set-local-rtc 1
```

# Bootloader Configuration
```
sudo nano /boot/limine.conf
```
### edit:
```
term_background: 00000000 #ffffffff
#wallpaper: boot():/limine-splash.png
```
## Secure Boot
### Install sbctl
```
sudo pacman -S sbctl
```
### Create and enroll keys
```
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft
```
### Edit limine config
```
sudo nano /etc/default/limine
ENABLE_ENROLL_LIMINE_CONFIG=yes
```
### Sign limine
```
sudo limine-enroll-config
sudo limine-update
```
### Reboot to UEFI and enable Secure Boot
```
systemctl reboot --firmware-setup
```
### Check Secure Boot status
```
sudo bootctl status
```

# Applications
## Cider Repo
```
curl -s https://repo.cider.sh/ARCH-GPG-KEY | sudo pacman-key --add -
sudo pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A61682
echo '[cidercollective]' | sudo tee -a /etc/pacman.conf
echo 'SigLevel = Required TrustedOnly' | sudo tee -a /etc/pacman.conf
echo 'Server = https://repo.cider.sh/arch' | sudo tee -a /etc/pacman.conf
sudo pacman -Syu
```
## Virtual Machine Manager
```
sudo pacman -S --needed --noconfirm qemu-full virt-manager swtpm
echo 'firewall_backend = "iptables"' | sudo tee -a /etc/libvirt/network.conf
sudo usermod -aG libvirt $USER
systemctl enable --now libvirtd.service
systemctl enable --now libvirtd.socket
sudo virsh net-autostart default
sudo ufw route allow from 192.168.122.0/24
```
## Pacman Packages
```
sudo pacman -S bazaar cava chromium cider cmake deja-dup discord dolphin-plugins dysk extra-cmake-modules ffmpeg flatpak git go jre-openjdk npm ntfs-3g ntfsprogs obs-studio-browser proton-pass proton-vpn-gtk-app terminus-font ttf-noto-nerd vlc vulkan-devel vulkan-tools
```
## Flatpak
```
flatpak install flathub org.blender.Blender io.github.maniacx.BudsLink com.calibre_ebook.calibre io.github.wartybix.Constrict com.github.huluti.Curtail com.github.tchx84.Flatseal com.github.tenderowl.frog it.mijorus.gearlever org.gimp.GIMP fr.handbrake.ghb org.jellyfin.JellyfinDesktop com.makemkv.MakeMKV md.obsidian.Obsidian org.kde.okular org.onlyoffice.desktopeditors io.github.alainm23.planify org.prismlauncher.PrismLauncher com.vysp3r.ProtonPlus org.qbittorrent.qBittorrent org.raspberrypi.rpi-imager org.vinegarhq.Sober org.mozilla.thunderbird app.twintaillauncher.ttl com.visualstudio.code dev.goats.xivlauncher com.yubico.yubioath app.zen_browser.zen us.zoom.Zoom 
```
## Other
### Darkly
```
sudo pacman -S --needed cmake extra-cmake-modules kdecoration qt6-declarative kcoreaddons kcmutils kcolorscheme kconfig kguiaddons kiconthemes kwindowsystem git qt5-declarative qt5-x11extras gcc make kcmutils5 frameworkintegration5 kconfigwidgets5 kiconthemes5 kirigami2 kwindowsystem5
```
```
cd ~/Projects
git clone --single-branch --depth=1 https://github.com/Bali10050/Darkly.git
cd Darkly
./install.sh
```
### Better Blur DX
```
sudo pacman -S --needed base-devel git extra-cmake-modules qt6-tools kwin
```
```
cd ~/Projects
git clone https://github.com/xarblu/kwin-effects-better-blur-dx
cd kwin-effects-better-blur-dx
chmod +x build.sh
./build.sh
```
### Klassy
```
sudo pacman -S --needed git frameworkintegration gcc-libs glibc kcmutils kcolorscheme kconfig kcoreaddons kdecoration kguiaddons ki18n kiconthemes kirigami kwidgetsaddons kwindowsystem qt6-base qt6-declarative qt6-svg xdg-utils extra-cmake-modules kcmutils5 frameworkintegration5 kconfigwidgets5 kiconthemes5 kirigami2 kwindowsystem5
```
```
cd ~/Projects
git clone https://github.com/paulmcauley/klassy
cd klassy
git checkout plasma6.3
./install.sh
```
### OpenLinkHub
```
cd ~/Projects
git clone https://github.com/jurkovic-nikola/OpenLinkHub.git
cd OpenLinkHub/
CGO_CFLAGS_ALLOW='-fno-strict-overflow' go build .
chmod +x install.sh
sudo ./install.sh
```
```
sudo rm /opt/OpenLinkHub/config.json
sudo wget -P /opt/OpenLinkHub https://raw.githubusercontent.com/badams700/linux-setup/main/Files/config.json
```
```
echo 'KERNEL=="i2c-13", MODE="0600", OWNER="openlinkhub"' | sudo tee /etc/udev/rules.d/98-corsair-memory.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
```
```
sudo systemctl restart OpenLinkHub.service
```
### Wallpaper Engine
```
sudo pacman -S --needed gst-plugin-pipewire gst-libav gst-plugins-bad-libs gst-plugins-good qt6-declarative qt6-websockets qt6-webchannel plasma-desktop libplasma vulkan-icd-loader lz4
```
```
cd ~/Projects
!!! sudo wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst
!!! sudo pacman -U ./WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst --overwrite '*'
```

# Customization
## Orchis Theme
```
cd ~/Projects
git clone https://github.com/badams700/Orchis-kde
cd Orchis-kde/
./install.sh
```
## Window Blur
```
cd ~/Projects
sudo wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/blur.kwinrule
```
## Fastfetch
```
mkdir ~/.config/fastfetch
wget -P ~/.config/fastfetch https://raw.githubusercontent.com/badams700/linux-setup/main/Files/config.jsonc
```
## TTY Font
```
echo 'FONT=ter-132b' | sudo tee -a /etc/vconsole.conf
```
## Install from KDE Widgets / Icons
- Kurve
- Panel Colorizer
- Plasmusic Toolbar
- KDE Control Station
- Simple Separator
- Papirus Icons
## KDE Layout
![KDE Layout](kde_layout.png)

# Other
## Hardware Acceleration Scripts
```
sudo wget -P ~/.config https://raw.githubusercontent.com/badams700/linux-setup/main/Files/chrome-flags.conf
sudo wget -P ~/Desktop https://raw.githubusercontent.com/badams700/linux-setup/main/Files/steam_dev.cfg
```
## Samba Share
```
sudo mkdir /mnt/Share
```
```
sudo nano /etc/fstab
//192.168.1.123/Share /mnt/Share cifs _netdev,nofail,uid=brad,username=badams,password=*password*,rw 0 0
```
