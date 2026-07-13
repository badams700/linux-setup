# Part 1
## Time
```
timedatectl set-local-rtc 1
```
## BTRFS Snapshots
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
sudoufw route allow from 192.168.122.0/24
```
## Identify Windows EFI Path
```
lsblk
```
## Copy Windows Bootloader
```
sudo mkdir /mnt/WinBoot
sudo mount /dev/<DRIVE> /mnt/WinBoot
sudo cp -r /mnt/WinBoot/EFI/Microsoft /boot/EFI
sudo umount /mnt/WinBoot
sudo rm -r /mnt/WinBoot
```
## systemd-boot Config
/boot/loader/loader.conf
```
default @saved
timeout 1
console-mode max
```
## Configure mkinitcpio for UKI
/etc/mkinitcpio.d/linux-cachyos.preset

/etc/mkinitcpio.d/linux-cachyos-rc.preset
```
#default_image="/boot/initramfs-linux-cachyos.img"
default_uki="/boot/EFI/Linux/cachyos.efi"

#default_image="/boot/initramfs-linux-cachyos-rc.img"
default_uki="/boot/EFI/Linux/cachyos-rc.efi"
```
## Edit Kernel Arguments
/etc/kernel/cmdline
```
acpi_enforce_resources=lax amdgpu.dcfeaturemask=0x402
```
## Generate UKI
```
sudo mkinitcpio -P
```
## Remove Kernel Image Folder and files in /boot
```
sudo rm /boot/initramfs-linux-cachyos.img /boot/initramfs-linux-cachyos-lts.img /boot/initramfs-linux-cachyos-rc.img /boot/loader/entries/linux-cachyos.conf /boot/loader/entries/linux-cachyos-lts.conf /boot/loadsr/entries/linux-cachyos-rc.conf
sudo su
cd /boot
ls
```
```
sudo rm -r <FOLDER>
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

# Part 2
## Install Yay
```
cd ~/Projects
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
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
