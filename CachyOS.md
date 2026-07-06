## Time Sync with Windows
```
timedatectl set-local-rtc 1
```
## BTRFS Snapshots 
```
- Btrfs Assistant
- Snapper Settings
- Number: 10
```
```
sudo cp /etc/limine-snapper-sync.conf /etc/limine-snapper-sync.conf.orig

sudo nano /etc/limine-snapper-sync.conf
```
```
MAX_SNAPSHOT_ENTRIES=10

SNAPSHOT_FORMAT_CHOICE=8
```
## Hardware Acceleration
```
sudo nano ~/.config/chrome-flags.conf
```
```
--ignore-gpu-blocklist
--enable-gpu-rasterization
--enable-zero-copy
--ozone-platform-hint=auto
--use-gl=angle
--use-angle=vulkan
--enable-features=VaapiVideoDecoder,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder,VaapiIgnoreDriverChecks,UseMultiPlaneFormatForHardwareVideo,Vulkan,VulkanFromANGLE,DefaultANGLEVulkan
```
## QEMU VMM
```
sudo pacman -S qemu-full virt-manager swtpm
echo 'firewall_backend = "iptables"' | sudo tee -a /etc/libvirt/network.conf
sudo usermod -aG libvirt $USER
systemctl enable --now libvirtd.service
systemctl enable --now libvirtd.socket
sudo virsh net-autostart default
sudo ufw route allow from 192.168.122.0/24
```
## Steam - Vulkan Shaders
```
sudo nano Desktop/steam_dev.cfg
```
```
unShaderBackgroundProcessingThreads 16
```
copy to ~/.local/share/Steam once Steam is installed
## Bootloader and Secure Boot
<details>
<summary> systemd-boot and Secure Boot </summary>

### Copy Windows Boot Manager to systemd-boot
```
sudo mkdir /mnt/WinBoot
sudo mount /dev/nvme<NUMBER> /mnt/WinBoot
sudo cp -r /mnt/WinBoot/EFI/Microsoft /boot/EFI
sudo umount /mnt/WinBoot
sudo rm -r /mnt/WinBoot
```
### Edit Kernel Arguments
```
sudo nano /etc/kernel/cmdline
```
```
acpi_enforce_resources=lax
```
### Reset UEFI to Setup Mode
```
systemctl reboot --firmware-setup
```
### Install and Configure sbctl
```
sudo pacman -S sbctl
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft --firmware-builtin
```
### Verify Binaries to Sign
```
sudo sbctl verify
```
### Batch Sign Binaries
```
sudo sbctl-batch-sign
```
### Reboot to UEFI and Ensure Secure Boot is On
```
systemctl reboot --firmware-setup
```
### Verify
```
sudo bootctl
```
</details>

<details>
<summary> Limine and Secure Boot <br/></summary>

### Edit Limine config file
```
sudo nano /boot/limine.conf
```
### Edit the following lines:
```
term_background: 00000000
- remove wallpaper line
```
### Reset UEFI to Setup Mode
```
systemctl reboot --firmware-setup
```
### Install and configure sbctl
```
sudo pacman -S sbctl
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft --firmware-builtin
```
### Configure Limine
```
sudo nano /etc/default/limine
```
### Add the following line and kernel argument:
```
ENABLE_ENROLL_LIMINE_CONFIG=yes
acpi_enforce_resources=lax
```
### Sign Limine
```
sudo limine-enroll-config
sudo limine-update
```
### Reboot to UEFI and Ensure Secure Boot is On
```
systemctl reboot --firmware-setup
```
### Verify
```
sudo bootctl
```
</details>

## AUR Helper
### Install yay
```
cd ~/Projects
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```
## Signing Keys and Repos
### Import Cider Signing Key
```
curl -s https://repo.cider.sh/ARCH-GPG-KEY | sudo pacman-key --add -
sudo pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A61682
```
### Add Cider Repo
```
sudo nano /etc/pacman.conf
```
```
[cidercollective]
SigLevel = Required TrustedOnly
Server = https://repo.cider.sh/arch
```
### Refresh pacman
```
sudo pacman -Syu
```
## Bulk Install Programs
```
yay -S flatpak obs-studio-browser amdgpu_top blender calf cava cdrdao cdrtools cider cmake deja-dup discord discover dolphin-plugins dvd+rw-tools dysk easyeffects extra-cmake-modules ffmpeg gimp git go handbrake jre-openjdk k3b lsp-plugins-lv2 mda.lv2 mission-center npm ntfs-3g ntfsprogs obsidian okular onlyoffice-bin openssh prismlauncher protonplus proton-pass proton-vpn-gtk-app rpi-imager terminus-font thunderbird transmission-gtk ttf-noto-nerd vlc zam-plugins darkly google-chrome kwin-effects-better-blur-dx qdiskinfo twintaillauncher-bin visual-studio-code-bin xivlauncher zoom && sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin && cd ~/Projects && wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/PKGBUILD && makepkg -si && flatpak install flathub io.github.maniacx.BudsLink io.github.wartybix.Constrict com.github.huluti.Curtail com.github.tchx84.Flatseal com.github.tenderowl.frog it.mijorus.gearlever org.jellyfin.JellyfinDesktop com.makemkv.MakeMKV io.github.alainm23.planify com.yubico.yubioath app.zen_browser.zen && bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/EasyEffects-Presets/master/install.sh)"
```
### KDE Discover
```
Kurve, Panel Colorizer, Plasmusic Toolbar, KDE Control Station, Simple Separator, Papirus Icons
```
## Console Font
```
sudo nano /etc/vconsole.conf
FONT=ter-132b
```
## OpenLinkHub - Corsair
### Build + Install
```
cd ~/Projects

git clone https://github.com/jurkovic-nikola/OpenLinkHub.git

cd OpenLinkHub/

CGO_CFLAGS_ALLOW='-fno-strict-overflow' go build .

chmod +x install.sh

sudo ./install.sh
```
### Configure RAM
```
sudo i2cdetect -l
```
### Find SMBUS controller
```
sudo dmidecode -t memory | grep 'Part Number'
```
### Add Memory Info
```
sudo nano /opt/OpenLinkHub/config.json
```
### Udev Rules
```
echo 'KERNEL=="i2c-18", MODE="0600", OWNER="openlinkhub"' | sudo tee /etc/udev/rules.d/98-corsair-memory.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
```
### Restart Service
```
sudo systemctl restart OpenLinkHub.service
```
## Automount Network Share
```
sudo mkdir /mnt/Share

sudo mkdir /mnt/oppa

sudo nano /etc/fstab
```
### Add to fstab:
```
//192.168.1.123/Share /mnt/Share cifs _netdev,nofail,uid=brad,username=badams,password=<password>,rw 0 0

UUID=7E7F-B856 /mnt/oppa exfat uid=1000,gid=1000,dmask=022,fmask=133,nofail 0 0
```
## Klassy
```
cd ~/Projects

git clone https://github.com/paulmcauley/klassy

cd klassy

git checkout plasma6.3

./install.sh
```
## KDE Wallpaper Engine
### Install Wallpaper Engine via Steam
```
cd ~/Projects

sudo wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst

sudo pacman -U ./WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst --overwrite '*'
```
## Orchis
```
cd ~/Projects

git clone https://github.com/badams700/Orchis-kde

cd Orchis-kde/

./install.sh
```
## Fastfetch
```
mkdir ~/.config/fastfetch

cd ~/.config/fastfetch

wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/config.jsonc
```
## KDE Blur
### Download
```
cd ~/Projects

wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/blur.kwinrule
```
- Import via Settings
## KDE Layout
![KDE Layout](kde_layout.png)
