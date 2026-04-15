## RPM Fusion ##
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install rpmfusion-free-appstream-data rpmfusion-nonfree-appstream-data

sudo dnf check-update

## Flatpak ##
flatpak remote-delete fedora

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Laptop Graphics ##
sudo dnf install -y libva-intel-driver

## Media Codecs ##
sudo dnf swap ffmpeg-free ffmpeg --allowerasing

sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

sudo dnf groupupdate sound-and-video

## Hardware Acceleration ##
sudo dnf install -y ffmpeg-libs libva libva-utils

## Firefox Video ##
sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264

sudo dnf config-manager --set-enabled fedora-cisco-openh264

sudo dnf update -y

## Archives ##
sudo dnf install -y p7zip p7zip-plugins unrar 

## AppImages ##
sudo dnf install -y fuse fuse-libs

flatpak install flathub it.mijorus.gearlever

## VSCode ##
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf install code

## Multimedia ##
sudo dnf install -y vlc

flatpak install -y flathub com.obsproject.Studio

## Productivity ##
flatpak install -y flathub org.onlyoffice.desktopeditors

## Utilities ##
flatpak install flathub io.missioncenter.MissionCenter

## Cleanup ##
sudo dnf clean all

sudo dnf autoremove -y

## GRUB Settings ##
sudo nano /etc/default/grub

GRUB_TIMEOUT=0

GRUB_TIMEOUT_STYLE=hidden

GRUB_HIDDEN_TIMEOUT_QUIET=true

sudo grub2-mkconfig -o /boot/grub2/grub.cfg

## Secure Boot and NVIDIA Drivers ##
mokutil --sb-state

sudo dnf update

# install RPM fusion repos

sudo dnf install kmodtool akmods mokutil openssl

sudo kmogenca -a

sudo mokutil --import /etc/pki/akmods/certs/public_key.der

systemctl reboot

sudo dnf install akmod-nvidia

sudo dnf install xorg-x11-drv-nvidia-cuda

modinfo -F version nvidia

systemctl reboot

nvidia-smi

## GDM HiDPI ##
sudo cp -f ~/.config/monitors.xml ~gdm/.config/monitors.xml

sudo chown $(id -u gdm):$(id -g gdm) ~gdm/.config/monitors.xml

sudo restorecon ~gdm/.config/monitors.xml
