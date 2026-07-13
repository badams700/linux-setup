#! /bin/bash
timedatectl set-local-rtc 1
pacman -S --noconfirm btrfs-assistant snapper snap-pac
pacman -S --noconfirm sbctl systemd-ukify
sed -i '2c\timeout 1' /boot/loader/loader.conf
sed -i '3c\console-mode max' /boot/loader/loader.conf
sed -i '11c\#default_image="/boot/initramfs-linux-cachyos.img"' /etc/mkinitcpio.d/linux-cachyos.preset
sed -i '12c\default_uki="/boot/EFI/Linux/cachyos.efi"' /etc/mkinitcpio.d/linux-cachyos.preset
sed -i '11c\#default_image="/boot/initramfs-linux-cachyos-rc.img"' /etc/mkinitcpio.d/linux-cachyos-rc.preset
sed -i '12c\default_uki="/boot/EFI/Linux/cachyos-rc.efi"' /etc/mkinitcpio.d/linux-cachyos-rc.preset
sed -i 's/$/ acpi_enforce_resources=lax amdgpu.dcfeaturemask=0x402/' /etc/kernel/cmdline
sbctl create-keys
sbctl enroll-keys -m -f
sbctl-batch-sign
systemctl reboot --firmware-setup
