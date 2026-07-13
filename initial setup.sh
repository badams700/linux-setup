#! /bin/bash
timedatectl set-local-rtc 1
pacman -S --noconfirm btrfs-assistant snapper snap-pac
mkdir /etc/snapper/configs
cd /etc/snapper/configs
wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/root
snapper create --type single --description "Base Installation"
pacman -Rs --noconfirm linux-cachyos-lts linux-cachyos-lts-headers
pacman -S --noconfirm linux-cachyos-rc linux-cachyos-rc-headers
pacman -S --noconfirm sbctl systemd-ukify
sed -i '2c\timeout 1' /boot/loader/loader.conf
sed -i '3c\console-mode max' /boot/loader/loader.conf
sed -i '11c\#default_image="/boot/initramfs-linux-cachyos.img"' /etc/mkinitcpio.d/linux-cachyos.preset
sed -i '12c\default_uki="/boot/EFI/Linux/cachyos.efi"' /etc/mkinitcpio.d/linux-cachyos.preset
sed -i '11c\#default_image="/boot/initramfs-linux-cachyos-rc.img"' /etc/mkinitcpio.d/linux-cachyos-rc.preset
sed -i '12c\default_uki="/boot/EFI/Linux/cachyos-rc.efi"' /etc/mkinitcpio.d/linux-cachyos-rc.preset
sed -i 's/$/ acpi_enforce_resources=lax amdgpu.dcfeaturemask=0x402/' /etc/kernel/cmdline
mkinitcpio -P
rm /boot/initramfs-linux-cachyos.img /boot/initramfs-linux-cachyos-lts.img /boot/initramfs-linux-cachyos-rc.img /boot/loader/entries/linux-cachyos.conf /boot/loader/entries/linux-cachyos-lts.conf /boot/loader/entries/linux-cachyos-rc.conf 
rm -r /boot/<kernel folder>
mkdir /mnt/WinBoot
mount /dev/nvme<>n<>p<> /mnt/WinBoot
cp -r /mnt/WinBoot/EFI/Microsoft /boot/EFI
umount /mnt/WinBoot
rm -r /mnt/WinBoot
sbctl create-keys
sbctl enroll-keys -m -f
sbctl-batch-sign
systemctl reboot --firmware-setup
