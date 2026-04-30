# CachyOS Setup
## Time Sync with Windows
```
timedatectl set-local-rtc 1
```
## Bootloader and Secure Boot
<details> 
<summary> UKI and Secure Boot </summary>
</details>

<details>
<summary> systemd-boot and Secure Boot </summary>
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
sudo sbctl enroll-keys --microsoft
```
### Configure Limine
```
sudo nano /etc/default/limine
```
### Add the following line:
```
ENABLE_ENROLL_LIMINE_CONFIG=yes
```
### Sign Limine
```
sudo limine-enroll-config
sudo limine-update
```
### To verify:
```
sudo sbctl status
```
### Reboot to UEFI and Ensure Secure Boot is On
```
systemctl reboot --firmware-setup
```
</details>

## AUR Helper
### Remove paru
```
sudo pacman -Rs paru
```
### Install yay
```
cd Projects/
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
### Import 1Password Signing Key
```
curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
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
### yay / pacman
```
yay -S --needed --noconfirm 1password blender bottles calibre cider cmake darkly discord ffmpeg flatpak gimp git go google-chrome handbrake minecraft-launcher mission-center npm obsidian onlyoffice-bin openssh rpi-imager tailscale terminus-font thunderbird transmission-gtk trayscale twintaillauncher-bin virt-manager visual-studio-code-bin vlc xivlauncher zoom brave-bin kwin-effects-better-blur-dx deja-dup cava jre-openjdk papirus-icon-theme plasma6-applets-kurve plasma6-applets-panel-colorizer plasma6-applets-plasmusic-toolbar
```
### Install OBS Separately
```
yay -S obs-studio-browser
```
### Flatpak
```
flatpak install flathub com.github.tenderowl.frog io.github.alainm23.planify io.github.kolunmi.Bazaar io.github.wartybix.Constrict it.mijorus.gearlever org.jellyfin.JellyfinDesktop
```
## Console Font
```
sudo echo "FONT=ter-132b" >> /etc/vconsole.conf
```
## OpenLinkHub - Corsair
### Build + Install
```
cd Projects/

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
echo 'KERNEL=="i2c-<NUMBER>", MODE="0600", OWNER="openlinkhub" | sudo tee /etc/udev/rules.d/98-corsair-memory.rules
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

sudo nano /etc/fstab
```
### Add to fstab:
```
//192.168.1.123/Share /mnt/Share cifs _netdev,nofail,uid=brad,username=badams,password=<password>,rw 0 0
```
## Klassy
```
cd Projects/

git clone https://github.com/paulmcauley/klassy

cd klassy

git checkout plasma6.3

./install.sh
```
## KDE Wallpaper Engine
### Install Wallpaper Engine via Steam - use Windows 7 compatibility mode 
```
cd Projects/

sudo wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.55d_arch/WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst

sudo pacman -U ./WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst --overwrite '*'
```
## Orchis
```
cd Projects/

git clone https://github.com/vinceliuice/Orchis-kde

cd Orchis-kde/

./install.sh
```
## Fastfetch
```
cd ~/.config
```
```
git clone https://github.com/badams700/fastfetch.git
```
## KDE Layout
![KDE Layout](link_to_image)
### KDE Store
- [ ] KDE Control Station
## Game Locations
### FFXIV
```
~/.xlcore/
```
### TwinTail
```
~/.local/share/twintaillauncher/games/
```
