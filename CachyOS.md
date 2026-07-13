## Identify Windows EFI Path
```
lsblk
```
## Identify Kernel Image Folder in /boot
```
sudo su
cd /boot
ls
```
## BTRFS Snapshot Info
- Btrfs Assistant
- Snapper Settings
- Number: 10
  
## Install Yay - cannot be root
```
cd ~/Projects
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Clone Repo
```
cd ~/Projects
git clone https://github.com/badams700/linux-setup
cd linux-setup
sudo nano script1.sh
# enter variables
sudo chmod +x script1.sh
sudo chmod +x script2.sh
./script1.sh
```

## Script 1
```
#!/bin/bash

# --- CONFIGURATION - PLEASE ENTER VARIABLES HERE ---
WIN_EFI="nvmexnxpx"
KERNEL_FOLDER=" "
# --- END CONFIGURATION ---

echo "Setting Time Zone..."
sleep 5
timedatectl set-local-rtc 1

echo "Setting up BTRFS Snapshots..."
pacman -S btrfs-assistant snapper snap-pac
echo "Please set up snapshots in BTRFS Assistant.
read -r -p "Press enter when complete."

# Hardware Acceleration
echo "Configuring Hardware Acceleration Scripts..."
sleep 5
cp ~/Projects/linux-setup/Files/chrome-flags.conf ~/.config
cp ~/Projects/linux-setup/Files/steam_dev.cfg ~/Desktop

# QEMU
echo "Installing Virtual Machine Packages..."
sleep 5
pacman -S --noconfirm qemu-full virt-manager swtpm
echo 'firewall_backend = "iptables"' | tee -a /etc/libvirt/network.conf
usermod -aG libvirt $USER
systemctl enable --now libvirtd.service
systemctl enable --now libvirtd.socket
virsh net-autostart default
ufw route allow from 192.168.122.0/24

# Bootloader and Secure Boot
echo "Setting up Secure Boot..."
sleep 5
sudo pacman -Rs linux-cachyos-lts linux-cachyos-lts-headers
sudo pacman -S linux-cachyos-rc linux-cachyos-rc-headers sbctl systemd-ukify
sudo mkdir /mnt/WinBoot
sudo mount /dev/${WIN_EFI} /mnt/WinBoot
sudo cp -r /mnt/WinBoot/EFI/Microsoft /boot/EFI
sudo umount /mnt/WinBoot
sudo rm -r /mnt/WinBoot
sudo sed -i '2c\timeout 1' /boot/loader/loader.conf
sudo sed -i '3c\console-mode max' /boot/loader/loader.conf
sudo sed -i '11c\#default_image="/boot/initramfs-linux-cachyos.img"' /etc/mkinitcpio.d/linux-cachyos.preset
sudo sed -i '12c\default_uki="/boot/EFI/Linux/cachyos.efi"' /etc/mkinitcpio.d/linux-cachyos.preset
sudo sed -i '11c\#default_image="/boot/initramfs-linux-cachyos-rc.img"' /etc/mkinitcpio.d/linux-cachyos-rc.preset
sudo sed -i '12c\default_uki="/boot/EFI/Linux/cachyos-rc.efi"' /etc/mkinitcpio.d/linux-cachyos-rc.preset
sudo sed -i 's/$/ acpi_enforce_resources=lax amdgpu.dcfeaturemask=0x402/' /etc/kernel/cmdline
sudo rm /boot/initramfs-linux-cachyos.img /boot/initramfs-cachyos-lts.img /boot/initramfs-linux-cachyos-rc.img /boot/loader/entries/linux-cachyos.conf /boot/loader/entries/linux-cachyos-lts.conf /boot/loader/entries/linux-cachyos-rc.conf
sudo rm -r /boot/${KERNEL_FOLDER}
sudo mkinitcpio -P
sudo sbctl create-keys
sudo sbctl enroll-keys -m -f
sudo sbctl-batch-sign
read -r -p "Please ensure all binaries are signed correctly and press enter to reboot to UEFI.
systemctl reboot --firmware-setup
```

## Script 2
```
echo "Running setup script 2."
sleep 5

echo "Configuring pacman repositories..."
sleep 5
# Cider Repo
curl -s https://repo.cider.sh/ARCH-GPG-KEY | sudo pacman-key --add -
sudo pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A61682
echo '[cidercollective]' | sudo tee -a /etc/pacman.conf
echo 'SigLevel = Required TrustedOnly' | sudo tee -a /etc/pacman.conf
echo 'Server = https://repo.cider.sh/arch' | sudo tee -a /etc/pacman.conf

echo "Installing software..."
sleep 5
#Install Programs
sudo pacman -Syu --needed --noconfirm flatpak obs-studio-browser amdgpu_top blender calibre cava cdrdao cdrtools cider cmake deja-dup discord discover dolphin-plugins dvd+rw-tools dysk extra-cmake-modules ffmpeg gimp git go handbrake jre-openjdk k3b npm ntfs-3g ntfsprogs obsidian okular onlyoffice-bin openssh prismlauncher protonplus proton-pass proton-vpn-gtk-app rpi-imager terminus-font thunderbird transmission-gtk ttf-noto-nerd vlc
yay -S --needed --noconfirm darkly google-chrome kwin-effects-better-blur-dx qdiskinfo twintaillauncher-bin visual-studio-code-bin xivlauncher zoom
flatpak install -y flathub io.github.maniacx.BudsLink io.github.wartybix.Constrict com.github.huluti.Curtail com.github.tchx84.Flatseal com.github.tenderowl.frog it.mijorus.gearlever org.jellyfin.JellyfinDesktop com.makemkv.MakeMKV io.github.alainm23.planify com.yubico.yubioath app.zen_browser.zen
echo 'FONT=ter-132b' | sudo tee -a /etc/vconsole.conf

# OpenLinkHub
cd ~/Projects
git clone https://github.com/jurkovic-nikola/OpenLinkHub.git
cd OpenLinkHub/
CGO_CFLAGS_ALLOW='-fno-strict-overflow' go build .
chmod +x install.sh
sudo ./install.sh
sudo rm /opt/OpenLinkHub/config.json
cp ~/Projects/linux-setup/Files/config.json /opt/OpenLinkHub
echo 'KERNEL=="i2c-18", MODE="0600", OWNER="openlinkhub"' | sudo tee /etc/udev/rules.d/98-corsair-memory.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo systemctl restart OpenLinkHub.service

echo "Configuring Samba mount..."
sleep 5
# Automount Network Share
sudo mkdir /mnt/Share /mnt/oppa
echo '//192.168.1.123/Share /mnt/Share cifs _netdev,nofail,uid=brad,username=badams,password=*password*,rw 0 0' | sudo tee -a /etc/fstab

echo "Configuring themes and layouts..."
sleep 5
# Cosmetic
cd ~/Projects
git clone https://github.com/paulmcauley/klassy
cd klassy
git checkout plasma6.3
./install.sh
cd ~/Projects/linux-setup/Files
sudo pacman -U ./WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst --overwrite '*'
cd ~/Projects
git clone https://github.com/badams700/Orchis-kde
cd Orchis-kde/
./install.sh
mkdir ~/.config/fastfetch
cp ~/Projects/linux-setup/Files/config.jsonc ~/.config/fastfetch

echo "Setup complete! Move the steam_dev.cfg file to ~/.local/share/Steam once installed. Import the kwin blur effects via System Settings."
read -r -p "Press Enter to exit."
exit
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
