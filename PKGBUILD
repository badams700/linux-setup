# Maintainer: Proton AG (Proton Mail Bridge developers) <bridge@protonmail.ch>
_pkgname=protonmail-bridge
pkgname=$_pkgname-bin
pkgver=3.25.0
pkgrel=1
pkgdesc="Proton Mail Bridge is a desktop application that runs in the background, encrypting and decrypting messages as they enter and leave your computer."
arch=("x86_64")
url="https://proton.me/mail/bridge"
license=("GPLv3")
depends=( 'libfido2' 'xcb-util-cursor' 'libglvnd' 'glibc' 'gcc-libs' 'glib2' 'ttf-dejavu' )
optdepends=( 'pass: pass support' 'gnome-keyring: gnome-keyring support')
conflicts=("$_pkgname" "$_pkgname-beta-bin")
provides=("$_pkgname")
source=("https://proton.me/download/bridge/protonmail-bridge_3.25.0-1_amd64.deb")
sha256sums=("6b0318f4f425ef1a19b63e2bd589bc1036d95f073cb9ac26b42c0fc63a8bc275")

package() {
  tar -xzC "$pkgdir" -f data.tar.gz
  rm -rf "$pkgdir/opt"
}
