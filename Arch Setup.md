# Arch / CachyOS Setup

## systemd-boot and Secure Boot Configuration

Identify Windows EFI partition (200MB, FAT32)
```
lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT
```

Mount Windows EFI
```
sudo mkdir /mnt/WinBoot
sudo mount /dev/<partition> /mnt/WinBoot
```

Copy Windows EFI
```
sudo cp -r /mnt/WinBoot/EFI/Microsoft /boot/EFI
```

Unmount Windows EFI
```
sudo umount /mnt/WinBoot
sudo rm -r /mnt/WinBoot
```

Edit Configuration
```
sudo nano /boot/loader/loader.conf
```

Secure Boot
```
systemctl reboot --firmware-setup
```
Clear keys

Install sbctl
```
sudo pacman -S sbctl
sudo sbctl status
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft
```

Sign EFI - Part 1
```
sudo sbctl verify
sudo sbctl-batch-sign
sudo sbctl verify
```
Reboot and enable Secure Boot. 

Sign EFI - Part 2
```
sudo sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
```

Verify
```
sudo sbctl status
```

## Limine and Secure Boot Configuration
Download black photo for background

Name limine-splash.png

Move to /boot
```
systemctl reboot --firmware-setup
```
Clear keys

Install sbctl
```
sudo pacman -S sbctl
sudo sbctl status
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft
```
Edit /etc/default/limine
```
ENABLE_ENROLL_LIMINE_CONFIG=yes
```
Sign Limine
```
sudo b2sum /boot/limine-splash.png
```
Copy the result hash to /boot/limine.conf - after limine-splash.png#<hash>
```
sudo limine-enroll-config
sudo limine-update
```
To verify:
```
sudo sbctl status
```

## Install Yay
```
sudo pacman -Rs paru
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```
## Cider Signing Key
```
curl -s https://repo.cider.sh/ARCH-GPG-KEY | sudo pacman-key --add -
sudo pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A61682
```

## Cider Repo
```
sudo nano /etc/pacman.conf
```
```
[cidercollective]
SigLevel = Required TrustedOnly
Server = https://repo.cider.sh/arch
```

## 1Password Signing Key
```
curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
```

## Refresh Pacman After Adding Keys
```
pacman -Sy
```

## Bulk Install Programs
```
yay -S --needed --noconfirm 1password blender bottles calibre cider cmake darkly discord ffmpeg flatpak gimp git go google-chrome handbrake minecraft-launcher mission-center npm obs-studio-browser obsidian onlyoffice-bin openssh rpi-imager tailscale terminus-font thunderbird transmission-gtk trayscale twintaillauncher-bin virt-manager visual-studio-code-bin vivaldi vlc xivlauncher zoom
```

## Change Console Font to HiDPI
```
sudo nano /etc/vconsole.conf
```
```
FONT=ter-132b
```

## Install Flatpak Programs
```
flatpak install flathub com.github.tenderowl.frog io.github.alainm23.planify io.github.kolunmi.Bazaar io.github.wartybix.Constrict it.mijorus.gearlever org.gnome.DejaDup org.jellyfin.JellyfinDesktop
```

## OpenLinkHub - Corsair
```
git clone https://github.com/jurkovic-nikola/OpenLinkHub.git

cd OpenLinkHub/

CGO_CFLAGS_ALLOW='-fno-strict-overflow' go build .

chmod +x install.sh

sudo ./install.sh
```

## Automount Network Share
sudo nano /etc/fstab
```
//192.168.1.123/Share /mnt/Share cifs _netdev,nofail,uid=badams,username=badams,password=Urba2143!,rw 0 0
```

## Klassy
```
sudo pacman -S --needed git frameworkintegration gcc-libs glibc kcmutils kcolorscheme kconfig kcoreaddons kdecoration kguiaddons ki18n kiconthemes kirigami kwidgetsaddons kwindowsystem qt6-base qt6-declarative qt6-svg xdg-utils extra-cmake-modules kcmutils5 frameworkintegration5 kconfigwidgets5 kiconthemes5 kirigami2 kwindowsystem5
```
```
git clone https://github.com/paulmcauley/klassy

cd klassy

git checkout plasma6.3

./install.sh
```

## KDE Wallpaper Engine
Install Wallpaper Engine via Steam - use Windows 7 compatibility mode 
```
sudo wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.55d_arch/WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst

sudo pacman -U ./WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst --overwrite '*'
```
## Fastfetch
Add config.jsonc to ~/badams/.config/fastfetch

## KDE Layout
App Menu
```
Chrome KCalc Konsole Minecraft
Mission Center Obsidian Onlyoffice OpenLinkHub
Planify Shelly Steam Settings
Thunderbird Twintail VLC XIVLauncher
```
Dock
```
App Launcher Dolphin 1Password Cider Discord Firefox
```
Themes / Widgets
```
Klassy
Darkly
Papirus Icons
Plasmusic Toolbar
Kurve - must install cava
KDE Control Station
Panel Colorizer
```
