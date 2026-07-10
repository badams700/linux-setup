```
timedatectl set-local-rtc 1
sudo cp /etc/limine-snapper-sync.conf /etc/limine-snapper-sync.conf.orig \
cd /etc \
sudo rm limine-snapper-sync.conf \
sudo wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/limine-snapper-sync.conf \
sudo pacman -R linux-cachyos-lts linux-cachyos-lts-headers \
sudo pacman -S linux-cachyos-rc linux-cachyos-rc-headers \
sudo pacman -S cachyos-gaming-meta cachyos-gaming-applications \
```
add term_background: 00000000 and comment wallpaper line in /boot/limine.conf
```
sudo pacman -S sbctl \
sudo sbctl create-keys \
sudo sbctl enroll-keys -m -f \
```
add acpi_enforce_resources=lax and amdgpu.dcfeaturemask=0x402 to /etc/default/limine
```
echo 'ENABLE_ENROLL_LIMINE_CONFIG=yes' | sudo tee -a /etc/default/limine \
sudo limine-enroll-config \
sudo limine-update \
systemctl reboot --firmware-setup 
```
