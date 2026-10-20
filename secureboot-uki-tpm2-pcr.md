## Install utilities 
```
sudo pacman -S sbctl systemd-ukify sbsigntool
```
## Edit mkinitcpio preset configuration
```
sudo nano /etc/mkinitcpio.d/linux-cachyos.preset
```
```
default_uki="/boot/EFI/Linux/cachyos.efi"
```
## Generate sbctl keys
```
sudo sbctl create-keys
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
```
## Disable sbctl hooks
```
sudo ln -sf /dev/null /etc/kernel/install.d/91-sbctl.install
sudo ln -sf /dev/null /usr/lib/kernel/install.d/91-sbctl.install
sudo ln -sf /dev/null /etc/pacman.d/hooks/zz-sbctl.hook
sudo ln -sf /dev/null /etc/initcpio/post/sbctl
```
## Enroll sbctl keys to UEFI
```
sudo sbctl enroll-keys -m
```
## Edit UKI configuration
```
sudo nano /etc/kernel/uki.conf
```
```
[PCRSignature:all]
PCRPrivateKey=/etc/systemd/tpm2-pcr-private-key.pem
PCRPublicKey=/etc/systemd/tpm2-pcr-public-key.pem
```
## Generate PCR keys
```
sudo openssl genrsa -out /etc/systemd/tpm2-pcr-private-key.pem 2048
sudo openssl rsa -in /etc/systemd/tpm2-pcr-private-key.pem -pubout -out /etc/systemd/tpm2-pcr-public-key.pem
```
## Regenerate signed UKI
```
sudo mkinitcpio -P
```
## Enroll TPM to LUKS
```
sudo systemd-cryptenroll /dev/nvme_n_p_ \
  --tpm2-device=auto \
  --tpm2-pcrs=0+2+7+12 \
  --tpm2-public-key=/etc/systemd/tpm2-pcr-public-key.pem
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
## Reboot to firmware and enable Secure Boot - ensure UKI shows up in boot menu
```
systemctl reboot --firmware-setup
```
## Remove systemd-boot if successful
```
sudo bootctl remove
```
