# Time
```
timedatectl set-local-rtc 1
```
# Snapshots
```
sudo pacman -S snapper snap-pac btrfs-assistant
```
Configure and take a base snapshot.
# Bootloader Configuration (systemd-boot)
## Install utilities 
```
sudo pacman -S sbctl systemd-ukify sbsigntools
```
## Edit mkinitcpio preset configuration
```
sudo vim /etc/mkinitcpio.conf
```
add modules "nvidia nvidia_modeset nvidia_uvm nvidia_drm"
```
sudo vim /etc/mkinitcpio.d/linux-cachyos.preset
```
```
default_uki="/boot/EFI/Linux/cachyos.efi"
```
Same for LTS
## Generate UKI
```
sudo mkinitcpio -P
```
Delete unneeded files from /boot
## Edit /boot/loader/loader.conf
```
sudo vim /boot/loader/loader.conf
```
```
default cachyos.efi
timeout 0
console-mode keep
```
## Generate sbctl keys
```
sudo sbctl create-keys
```
## Enroll sbctl keys to UEFI
```
sudo sbctl enroll-keys -m
```
## Sign files
```
sudo sbctl-batch-sign
```
## Reboot to firmware and enable Secure Boot
```
systemctl reboot --firmware-setup
```
## Confirm Secure Boot is on
```
sudo sbctl status
```
```
sudo bootctl status
```
## CachyOS Recovery
```
sudo pacman -S cachyos-recovery
```
## Easy Anti-Cheat v2
```
sudo eac-setup
```
```
sudo eac-setup boot
```
```
sudo eac-status
```
# Applications
## Cider Repo
```
curl -s https://repo.cider.sh/ARCH-GPG-KEY | sudo pacman-key --add -
sudo pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A61682
echo '[cidercollective]' | sudo tee -a /etc/pacman.conf
echo 'SigLevel = Required TrustedOnly' | sudo tee -a /etc/pacman.conf
echo 'Server = https://repo.cider.sh/arch' | sudo tee -a /etc/pacman.conf
sudo pacman -Syu cider
```
## Yay
```
sudo pacman -S yay
```
## Install packages
```
yay -S --needed 1password bazaar blender cava cmake ddcutil-service discord dysk epic-games-launcher-bin extra-cmake-modules ffmpeg flatpak fragments gimp git go handbrake impression jre-openjdk mission-center npm ntfs-3g ntfsprogs obs-studio-browser obsidian onlyoffice-bin openrgb prismlauncher protonplus proton-vpn-gtk-app qdiskinfo rpi-imager terminus-font thunderbird ttf-noto-nerd twintaillauncher-bin video-trimmer visual-studio-code-bin vlc xivlauncher zoom
```
## Flatpak
```
flatpak install flathub com.rafaelmardojai.Blanket io.github.maniacx.BudsLink io.github.wartybix.Constrict com.github.huluti.Curtail com.github.tchx84.Flatseal com.github.tenderowl.frog it.mijorus.gearlever com.makemkv.MakeMKV io.github.alainm23.planify org.vinegarhq.Sober org.waywallen.waywallen app.zen_browser.zen 
```
## Calibre
```
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
```
## Hardware Acceleration Scripts
```
sudo wget -P ~/.config https://raw.githubusercontent.com/badams700/linux-setup/main/Files/chrome-flags.conf
sudo wget -P ~/Desktop https://raw.githubusercontent.com/badams700/linux-setup/main/Files/steam_dev.cfg
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
## KDE Applications
```
yay -S --needed bup darkly dolphin-plugins kup kwin-effects-better-blur-dx okular plasma6-applets-audio-visualizer plasma6-applets-panel-colorizer
```
## Klassy
```
sudo pacman -S --needed git frameworkintegration gcc-libs glibc kcmutils kcolorscheme kconfig kcoreaddons kdecoration kguiaddons ki18n kiconthemes kwidgetsaddons kwindowsystem qt6-base qt6-declarative qt6-svg xdg-utils extra-cmake-modules kcmutils5 frameworkintegration5 kconfigwidgets5 kiconthemes5 kwindowsystem5
```
```
cd ~/Projects
git clone https://github.com/paulmcauley/klassy
cd klassy
git checkout plasma6.6
./install.sh
```
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
## Papirus Icons
```
wget -qO- https://git.io/papirus-icon-theme-install | sh
```
```
wget -qO- https://git.io/papirus-folders-install | sh
```
```
papirus-folders -C palebrown --theme Papirus-Dark
```
## Install from KDE Widgets
- CatWalk
- Plasmusic Toolbar
- KDE Control Station
- Simple Separator
- Window Title Reborn
