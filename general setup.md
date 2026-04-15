## Install Yay ##
> git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

## Cider Signing Key ##
curl -s https://repo.cider.sh/ARCH-GPG-KEY | sudo pacman-key --add -
sudo pacman-key --lsign-key A0CD6B993438E22634450CDD2A236C3F42A61682

## Cider Repo ##
sudo nano /etc/pacman.conf

[cidercollective]

SigLevel = Required TrustedOnly

Server = https://repo.cider.sh/arch

## 1Password Signing Key ##
curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import

pacman -Sy

## Bulk Install Programs ##
yay -S --needed --noconfirm 1password blender bottles calibre cider cmake darkly discord ffmpeg flatpak gimp git go google-chrome handbrake minecraft-launcher mission-center npm obs-studio-browser obsidian onlyoffice-bin openssh rpi-imager tailscale terminus-font thunderbird transmission-gtk trayscale twintaillauncher-bin virt-manager visual-studio-code-bin vivaldi vlc xivlauncher zoom

## Change Console Font to HiDPI ##
sudo nano /etc/vconsole.conf

FONT=ter-132b

## Install Flatpak Programs ##
flatpak install flathub com.github.tenderowl.frog io.github.alainm23.planify io.github.kolunmi.Bazaar io.github.wartybix.Constrict it.mijorus.gearlever org.gnome.DejaDup org.jellyfin.JellyfinDesktop

## OpenLinkHub - Corsair ##
git clone https://github.com/jurkovic-nikola/OpenLinkHub.git

cd OpenLinkHub/

CGO_CFLAGS_ALLOW='-fno-strict-overflow' go build .

chmod +x install.sh

sudo ./install.sh

## Klassy ##
sudo pacman -S --needed git frameworkintegration gcc-libs glibc kcmutils kcolorscheme kconfig kcoreaddons kdecoration kguiaddons ki18n kiconthemes kirigami kwidgetsaddons kwindowsystem qt6-base qt6-declarative qt6-svg xdg-utils extra-cmake-modules kcmutils5 frameworkintegration5 kconfigwidgets5 kiconthemes5 kirigami2 kwindowsystem5

git clone https://github.com/paulmcauley/klassy

cd klassy

git checkout plasma6.3

./install.sh

## KDE Wallpaper Engine ##
Install Wallpaper Engine via Steam - use Windows 7 compatibility mode 

sudo wget https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin/releases/download/0.55d_arch/WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst

sudo pacman -U ./WallpaperEngine_kde6-1.1e-1-x86_64.pkg.tar.zst --overwrite '*'
