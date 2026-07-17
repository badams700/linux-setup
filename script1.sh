#!/bin/bash
set -e

# NOTE: This script expects to be run with sudo, targeting a specific
# non-root user. Set TARGET_USER below instead of relying on $USER/$HOME,
# which get reset to root when run via sudo.
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)

# -- Time Zone --
timedatectl set-local-rtc 1

# -- BTRFS Snapshots --
pacman -S --needed --noconfirm btrfs-assistant snapper snap-pac
read -p "Please configure BTRFS snapshots in BTRFS Assistant. Press [Enter] to continue."

# -- Application Configs --
wget -P "$TARGET_HOME/.config" https://raw.githubusercontent.com/badams700/linux-setup/main/Files/chrome-flags.conf
wget -P "$TARGET_HOME/Desktop" https://raw.githubusercontent.com/badams700/linux-setup/main/Files/steam_dev.cfg

# -- QEMU VM --
pacman -S --needed --noconfirm qemu-full virt-manager swtpm
echo 'firewall_backend = "iptables"' | tee -a /etc/libvirt/network.conf
usermod -aG libvirt "$TARGET_USER"
systemctl enable --now libvirtd.service
systemctl enable --now libvirtd.socket
virsh net-autostart default
ufw route allow from 192.168.122.0/24
sleep 5

# -- Unified Kernel Image --
echo "Configuring Unified Kernel Image..."
sleep 5
pacman -S --needed --noconfirm sbctl systemd-ukify
sed -i '11c\#default_image="/boot/initramfs-linux-cachyos.img"' /etc/mkinitcpio.d/linux-cachyos.preset
sed -i '12c\default_uki="/boot/EFI/Linux/cachyos.efi"' /etc/mkinitcpio.d/linux-cachyos.preset
sed -i '11c\#default_image="/boot/initramfs-linux-cachyos-rc.img"' /etc/mkinitcpio.d/linux-cachyos-rc.preset
sed -i '12c\default_uki="/boot/EFI/Linux/cachyos-rc.efi"' /etc/mkinitcpio.d/linux-cachyos-rc.preset
sed -i 's/$/ acpi_enforce_resources=lax plymouth.use-simpledrm=1 amdgpu.dcfeaturemask=0x402 video=HDMI-1:3840x2160@160/' /etc/kernel/cmdline
sed -i '1c\default 2' /boot/loader/loader.conf
sed -i '2c\timeout 0' /boot/loader/loader.conf
sed -i '3c\console-mode max' /boot/loader/loader.conf
mkinitcpio -P

# -- Windows EFI Files --
echo "Finding Windows EFI partition..."
sleep 5
efi_partition=$(lsblk -p -n -l -o NAME,SIZE,FSTYPE,PARTTYPE | awk '
    $2 ~ /200M/ && $3 == "vfat" && $4 ~ /c12a7328-f81f-11d2-ba4b-00a0c93ec93b/ {
        print $1
        }')

if [ -z "$efi_partition" ]; then
    echo "Partition not found. Aborting before Secure Boot setup."
    exit 1
else
    echo "Found EFI Partition: $efi_partition"
fi
sleep 5

# -- Secure Boot --
echo "Configuring Secure Boot..."
mkdir -p /mnt/WinBoot
mount "$efi_partition" /mnt/WinBoot
cp -r /mnt/WinBoot/EFI/Microsoft /boot/EFI
umount /mnt/WinBoot
rm -rf /mnt/WinBoot
rm -f /boot/initramfs-linux-cachyos.img /boot/loader/entries/linux-cachyos.conf /boot/loader/entries/linux-cachyos-lts.conf

kernel_folder=""
for dir in /boot/*; do
    dir_clean=${dir%/}
    if [ -d "$dir" ]; then
        folder_name=$(basename "$dir")
        # Only consider purely numeric folder names (kernel version dirs),
        # so we don't try to numerically compare things like "EFI" or "loader".
        if [[ "$folder_name" =~ ^[0-9]+$ ]] && [ "$folder_name" -gt 10 ]; then
            kernel_folder="$dir_clean"
            break
        fi
    fi
done

if [ -n "$kernel_folder" ]; then
    echo "Removing old kernel folder: $kernel_folder"
    rm -rf "$kernel_folder"
else
    echo "No matching old kernel folder found under /boot, skipping removal."
fi
sleep 3

sbctl create-keys
sbctl enroll-keys -m -f
sbctl verify
read -p "Please ensure all files to be signed are present. Press [Enter] to continue."
sbctl-batch-sign
read -p "Secure Boot setup complete. Press [Enter] to reboot to UEFI and enable Secure Boot."
systemctl reboot --firmware-setup
