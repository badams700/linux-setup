## Generate PCR keys
```
sudo openssl genrsa -out /etc/systemd/tpm2-pcr-private-key.pem 2048
sudo openssl rsa -in /etc/systemd/tpm2-pcr-private-key.pem -pubout -out /etc/systemd/tpm2-pcr-public-key.pem
```
## Edit UKI configuration
```
sudo nano /etc/kernel/uki.conf
```
```
[UKI]
SecureBootSigningTool=sbsign
SecureBootPrivateKey=/var/lib/sbctl/keys/db/db.key
SecureBootCertificate=/var/lib/sbctl/keys/db/db.pem

[PCRSignature:all]
PCRPrivateKey=/etc/systemd/tpm2-pcr-private-key.pem
PCRPublicKey=/etc/systemd/tpm2-pcr-public-key.pem
```
## Disable sbctl hooks
```
sudo ln -sf /dev/null /etc/kernel/install.d/91-sbctl.install
sudo ln -sf /dev/null /usr/lib/kernel/install.d/91-sbctl.install
sudo ln -sf /dev/null /etc/pacman.d/hooks/zz-sbctl.hook
sudo ln -sf /dev/null /etc/initcpio/post/sbctl
```

## Add UKI to UEFI boot menu
```
sudo efibootmgr \
  --create \
  --disk /dev/nvme_n_ \
  --part _ \
  --label "CachyOS" \
  --loader /EFI/Linux/cachyos.efi \
  --unicode
```

## Enroll TPM to LUKS
```
sudo systemd-cryptenroll /dev/nvme_n_p_ \
  --tpm2-device=auto \
  --tpm2-pcrs=0+2+7+12 \
  --tpm2-public-key=/etc/systemd/tpm2-pcr-public-key.pem
```
## Remove systemd-boot if successful
```
sudo bootctl remove
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

## Wallpaper Engine
```
sudo pacman -S --needed gst-plugin-pipewire gst-libav gst-plugins-bad-libs gst-plugins-good qt6-declarative qt6-websockets qt6-webchannel plasma-desktop libplasma vulkan-icd-loader lz4
```
```
cd ~/Projects
sudo wget https://raw.githubusercontent.com/badams700/linux-setup/main/Files/WallpaperEngine_kde6-1_1k-1-x86_64.pkg.tar.zst
sudo pacman -U ./WallpaperEngine_kde6-1_1k-1-x86_64.pkg.tar.zst --overwrite '*'
```
  
## GNOME Extensions
- App Hider
- Better Tray Icons
- Blur My Shell
- Caffeine
- Dash to Dock
- GSConnect
- Hide System Icons
- Just Perfectionn
- Multi Display Adjustment
## Yay
```
yay -S ddcutil-service alacarte
```
## Flatpak
```
flatpak install flathub com.mattjakeman.ExtensionManager io.github.realmazharhussain.GdmSettings io.gitlab.adhami3310.Impression org.gnome.World.PikaBackup
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
Adjust Icons in GNOME Tweaks.
## Cursor
Capitaine Cursor: https://www.gnome-look.org/p/1148692
```
cd ~/Projects
tar xf capitaine-cursors-r4.tar.gz
sudo cp -r capitaine-cursors ~/.local/share/icons
```
Set cursor in GNOME Tweaks.
## GNOME Layout
![GNOME Layout](gnome-layout.png)


