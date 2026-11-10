# Snapshots
```
sudo pacman -S snapper snap-pac btrfs-assistant
```
```
sudo snapper -c root create-config /
```
```
sudo snapper -c root create --description "Base CachyOS Installation"
```
# Bootloader
## EAC
```
sudo eac-setup
```
```
sudo vim /boot/loader/loader.conf
```
```
default linux-cachyos.conf
timeout 0
console-mode 1
```
```
sudo rm /boot/loader/entries/linux-cachyos-eac.conf
```
Test EAC kernel:
```
sudo eac-status boot
```
```
sudo eac-status
```
# Dux Shell
```
curl -fsSL https://install.duxlabs.dev | sh
```
# Applications
## Yay
```
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```
## Cider
```
curl -s https://repo.cider.sh/ARCH-GPG-KEY | sudo pacman-key --add -
sudo pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A61682
echo '[cidercollective]' | sudo tee -a /etc/pacman.conf
echo 'SigLevel = Required TrustedOnly' | sudo tee -a /etc/pacman.conf
echo 'Server = https://repo.cider.sh/arch' | sudo tee -a /etc/pacman.conf
sudo pacman -Syu cider
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
## Calibre
```
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
```
## Packages
```
yay -S --needed --noconfirm 1password adw-gtk-theme baobab bazaar blender cava cmake cups-pk-helper ddcutil-service decibels deja-dup discord dysk extra-cmake-modules ffmpeg file-roller flatpak fragments fwupd gimp git gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-disk-utility gnome-font-viewer gnome-maps gnome-text-editor handbrake impression jre-openjdk kimageformats loupe nautilus nerdfetch npm ntfs-3g ntfsprogs obs-studio-browser obsidian onlyoffice-bin openrgb papers prismlauncher protonplus proton-vpn-gtk-app rpi-imager showtime terminus-font thunderbird ttf-noto-nerd twintaillauncher-bin video-trimmer visual-studio-code-bin vlc xivlauncher zoom 
