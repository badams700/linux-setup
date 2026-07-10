#! /bin/bash
timedatectl set-local-rtc 1
cp /etc/limine-snapper-sync.conf /etc/limine-snapper-sync.conf.orig
cd /etc
rm limine-snapper-sync.conf
wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/limine-snapper-sync.conf
pacman -R --noconfirm linux-cachyos-lts linux-cachyos-lts-headers
pacman -S --noconfirm linux-cachyos-rc linux-cachyos-rc-headers cachyos-gaming-meta cachyos-gaming-applications sbctl
sed -i '1c\timeout: 1' /boot/limine.conf
sed -i '[]c\term_background: 00000000' /boot/limine.conf
sed -i '[]c\[wallpaper syntax]' /boot/limine.conf
sbctl create-keys
sbctl enroll-keys -m -f
sed -i '/^CMDLINE=/s/"[^"]*"/"& acpi_enforce_resources=lax amdgpu.dcfeaturemask=0x402"/' /etc/default/limine
echo 'ENABLE_ENROLL_LIMINE_CONFIG=yes' | tee -a /etc/default/limine
limine-enroll-config
limine-update
systemctl reboot --firmware-setup
