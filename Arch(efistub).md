# Time
```
timedatectl set-local-rtc 1
```
# BTRFS Snapshots
```
sudo pacman -S --needed --noconfirm btrfs-assistant snapper snap-pac
```
- BTRFS Assistant
- Snapper Settings
- Number: 10
- Create a snapshot of the base install
## Hardware Acceleration Scripts
```
sudo wget -P ~/.config https://raw.githubusercontent.com/badams700/linux-setup/main/Files/chrome-flags.conf
sudo wget -P ~/Desktop https://raw.githubusercontent.com/badams700/linux-setup/main/Files/steam_dev.cfg
```
## QEMU VM
```
sudo pacman -S --needed --noconfirm qemu-full virt-manager swtpm
echo 'firewall_backend = "iptables"' | sudo tee -a /etc/libvirt/network.conf
sudo usermod -aG libvirt $USER
systemctl enable --now libvirtd.service
systemctl enable --now libvirtd.socket
sudo virsh net-autostart default
sudo ufw route allow from 192.168.122.0/24
```
## Identify Windows EFI Path
```
lsblk
```
## Configure mkinitcpio for UKI
/etc/mkinitcpio.d/linux-cachyos.preset
```
#default_image="/boot/initramfs-linux-cachyos.img"
default_uki="/boot/EFI/Linux/cachyos.efi"
```
/etc/mkinitcpio.d/linux-cachyos-rc.preset
```
#default_image="/boot/initramfs-linux-cachyos-rc.img"
default_uki="/boot/EFI/Linux/cachyos-rc.efi"
```
## Edit Kernel Arguments
/etc/kernel/cmdline
```
acpi_enforce_resources=lax
```
## Install sbctl and ukify
```
sudo pacman -S --needed --noconfirm sbctl systemd-ukify
```
## Generate UKI
```
sudo mkinitcpio -P
```
## Remove Kernel Image Folder and files in /boot
```
sudo rm /boot/initramfs-linux-cachyos.img /boot/initramfs-linux-cachyos-rc.img /boot/loader/entries/linux-cachyos.conf /boot/loader/entries/linux-cachyos-rc.conf /boot/loader/entries/linux-cachyos-lts.conf
```
```
sudo su
cd /boot
ls
rm <folder>
exit
```
## Secure Boot
```
sudo sbctl create-keys
sudo sbctl enroll-keys -m -f
sudo sbctl verify
```
Ensure all correct files are present
```
sudo sbctl-batch-sign
```
Reboot to UEFI and turn Secure Boot ON
```
systemctl reboot --firmware-setup
```
## Cider Repo
```
curl -s https://repo.cider.sh/ARCH-GPG-KEY | sudo pacman-key --add -
sudo pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A61682
echo '[cidercollective]' | sudo tee -a /etc/pacman.conf
echo 'SigLevel = Required TrustedOnly' | sudo tee -a /etc/pacman.conf
echo 'Server = https://repo.cider.sh/arch' | sudo tee -a /etc/pacman.conf
```

## Install Software
```
sudo pacman -Syu --needed --noconfirm blender calibre cava cdrdao cdrtools chromium cider cmake code deja-dup discord discover dolphin-plugins dvd+rw-tools dysk extra-cmake-modules ffmpeg flatpak gimp git go handbrake i2c-tools jre-openjdk k3b npm ntfs-3g ntfsprogs obs-studio-browser obsidian okular onlyoffice-bin openssh prismlauncher protonplus proton-pass proton-vpn-gtk-app rpi-imager terminus-font thunderbird transmission-gtk ttf-noto-nerd vlc
```
```
flatpak install -y flathub io.github.maniacx.BudsLink io.github.wartybix.Constrict com.github.huluti.Curtail com.github.tchx84.Flatseal com.github.tenderowl.frog it.mijorus.gearlever org.jellyfin.JellyfinDesktop com.makemkv.MakeMKV io.github.alainm23.planify com.yubico.yubioath app.zen_browser.zen org.vinegarhq.Sober us.zoom.Zoom app.twintaillauncher.ttl
```

## OpenLinkHub
```
cd ~/Projects
git clone https://github.com/jurkovic-nikola/OpenLinkHub.git
cd OpenLinkHub/
CGO_CFLAGS_ALLOW='-fno-strict-overflow' go build .
sudo chmod +x install.sh
sudo ./install.sh
sleep 3
sudo rm /opt/OpenLinkHub/config.json
sudo wget -P /opt/OpenLinkHub https://raw.githubusercontent.com/badams700/linux-setup/main/Files/config.json
sleep 3
echo 'KERNEL=="i2c-11", MODE="0600", OWNER="openlinkhub"' | sudo tee /etc/udev/rules.d/98-corsair-memory.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo systemctl restart OpenLinkHub.service
```

## Samba Share
```
sudo mkdir /mnt/Share /mnt/oppa
echo '//192.168.1.123/Share /mnt/Share cifs _netdev,nofail,uid=brad,username=badams,password=*password*,rw 0 0' | sudo tee -a /etc/fstab
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
## Steam - XIVLauncher
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Blooym/xlm/main/setup/install-native.sh)"
```
# KDE Customization
## Darkly
```
sudo pacman -S --needed cmake extra-cmake-modules kdecoration qt6-declarative kcoreaddons kcmutils kcolorscheme kconfig kguiaddons kiconthemes kwindowsystem git qt5-declarative qt5-x11extras gcc make kcmutils5 frameworkintegration5 kconfigwidgets5 kiconthemes5 kirigami2 kwindowsystem5
```
```
cd ~/Projects
git clone --single-branch --depth=1 https://github.com/Bali10050/Darkly.git
cd Darkly
./install.sh
```
## Klassy
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
## Wallpaper Engine
```
cd ~/Projects
sudo wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst
sudo pacman -U ./WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst --overwrite '*'
```
## Orchis Theme
```
cd ~/Projects
git clone https://github.com/badams700/Orchis-kde
cd Orchis-kde/
./install.sh
```
## Kwin Better Blur
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
## Window Blur
```
cd ~/Projects
sudo wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/blur.kwinrule
```
### KDE Discover
- Kurve
- Panel Colorizer
- Plasmusic Toolbar
- KDE Control Station
- Simple Separator
- Papirus Icons

## KDE Layout
![KDE Layout](kde_layout.png)
