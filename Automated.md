## 1. Time Zone and Snapshots
```
timedatectl set-local-rtc 1
sudo pacman -S btrfs-assistant snapper snap-pac
```
## 2. Snapshot Configuration
- Btrfs Assistant
- Snapper Settings
- Number: 10
## 3. Configurations
```
sudo wget -P ~/.config https://raw.githubusercontent.com/badams700/linux-setup/main/Files/chrome-flags.conf
sudo wget -P ~/.config https://raw.githubusercontent.com/badams700/linux-setup/main/Files/steam_dev.cfg
sudo pacman -S qemu-full virt-manager swtpm
echo 'firewall_backend = "iptables"' | sudo tee -a /etc/libvirt/network.conf
sudo usermod -aG libvirt $USER
systemctl enable --now libvirtd.service
systemctl enable --now libvirtd.socket
sudo virsh net-autostart default
sudo ufw route allow from 192.168.122.0/24
```
