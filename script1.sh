#!/bin/bash

# --- CONFIGURATION - PLEASE ENTER VARIABLES HERE ---
WIN_EFI="nvmexnxpx"
KERNEL_FOLDER=" "
# --- END CONFIGURATION ---

echo "Setting Time Zone..."
sleep 5
timedatectl set-local-rtc 1

echo "Setting up BTRFS Snapshots..."
pacman -S --needed --noconfirm btrfs-assistant snapper snap-pac
echo "Please set up snapshots in BTRFS Assistant."
read -r -p "Press enter when complete."

# Hardware Acceleration
echo "Configuring Hardware Acceleration Scripts..."
sleep 5
cp ~/Projects/linux-setup/Files/chrome-flags.conf ~/.config
cp ~/Projects/linux-setup/Files/steam_dev.cfg ~/Desktop

# QEMU
echo "Installing Virtual Machine Packages..."
sleep 5
pacman -S --needed --noconfirm qemu-full virt-manager swtpm
echo 'firewall_backend = "iptables"' | tee -a /etc/libvirt/network.conf
usermod -aG libvirt $USER
systemctl enable --now libvirtd.service
systemctl enable --now libvirtd.socket
virsh net-autostart default
ufw route allow from 192.168.122.0/24

# Bootloader and Secure Boot
echo "Setting up Secure Boot..."
sleep 5
pacman -Rs --noconfirm linux-cachyos-lts linux-cachyos-lts-headers
pacman -S --needed --noconfirm linux-cachyos-rc linux-cachyos-rc-headers sbctl systemd-ukify
mkdir /mnt/WinBoot
mount /dev/${WIN_EFI} /mnt/WinBoot
cp -r /mnt/WinBoot/EFI/Microsoft /boot/EFI
umount /mnt/WinBoot
rm -r /mnt/WinBoot
sed -i '2c\timeout 1' /boot/loader/loader.conf
sed -i '3c\console-mode max' /boot/loader/loader.conf
sed -i '11c\#default_image="/boot/initramfs-linux-cachyos.img"' /etc/mkinitcpio.d/linux-cachyos.preset
sed -i '12c\default_uki="/boot/EFI/Linux/cachyos.efi"' /etc/mkinitcpio.d/linux-cachyos.preset
sed -i '11c\#default_image="/boot/initramfs-linux-cachyos-rc.img"' /etc/mkinitcpio.d/linux-cachyos-rc.preset
sed -i '12c\default_uki="/boot/EFI/Linux/cachyos-rc.efi"' /etc/mkinitcpio.d/linux-cachyos-rc.preset
sed -i 's/$/ acpi_enforce_resources=lax amdgpu.dcfeaturemask=0x402/' /etc/kernel/cmdline
rm /boot/initramfs-linux-cachyos.img /boot/initramfs-cachyos-lts.img /boot/initramfs-linux-cachyos-rc.img /boot/loader/entries/linux-cachyos.conf /boot/loader/entries/linux-cachyos-lts.conf /boot/loader/entries/linux-cachyos-rc.conf
rm -r /boot/${KERNEL_FOLDER}
mkinitcpio -P
sbctl create-keys
sbctl enroll-keys -m -f
sbctl-batch-sign
read -r -p "Please ensure all binaries are signed correctly and press enter to reboot to UEFI.
systemctl reboot --firmware-setup
