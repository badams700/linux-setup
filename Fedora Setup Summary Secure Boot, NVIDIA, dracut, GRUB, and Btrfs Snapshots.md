# Fedora Setup Summary: Secure Boot, NVIDIA, dracut, GRUB, and Btrfs Snapshots

Prepared November 20, 2026

This document collects four setup tasks for a fresh Fedora install: Secure Boot with NVIDIA drivers, early-loading the NVIDIA modules through dracut, hiding the GRUB menu, and Btrfs snapshots with Snapper. Commands are from knowledge, so check package names and paths against your Fedora release.

## Suggested order

1. Update the system and enable RPM Fusion.
2. Create and enroll a Secure Boot signing key, then install the NVIDIA driver.
3. Optionally add the NVIDIA modules to the initramfs with dracut.
4. Tidy up the GRUB menu.
5. Set up Btrfs snapshots once the system is stable, so your first snapshot is a good one.

## 1. Secure Boot and NVIDIA drivers

Enroll your signing key first, then install the driver, so the kernel module is signed on its first build.

1. **Update:** `sudo dnf upgrade --refresh`, then reboot if a new kernel was installed.
2. **Enable RPM Fusion** (free and nonfree) using the instructions at rpmfusion.org/Configuration.
3. **Create and enroll a signing key:**

```
sudo dnf install kmodtool akmods mokutil openssl
sudo kmodgenca -a
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
```

Set a one-time password when prompted, then reboot.

4. **At the blue MOK screen:** choose Enroll MOK, then Continue, then Yes, enter the password, and reboot.
5. **Install the driver:**

```
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda
```

The CUDA package is optional, but it also provides `nvidia-smi`.

6. **Wait for the module to build**, about 5 minutes. Check with `modinfo -F version nvidia`. Do not reboot until it prints a version number.
7. **Reboot and verify:** run `nvidia-smi` and `mokutil --sb-state`. Secure Boot should report enabled.

### Common problems

- **Black screen or nouveau still loading:** the module was not built or signed. Run `sudo akmods --force --rebuild`, then `sudo dracut --force`, and reboot.
- **Key enrolled after the driver was installed:** same fix as above.
- **Kernel updates:** akmods rebuilds and signs the module automatically with your key.
- **Newer cards (RTX 50 series):** these need the open kernel modules. Check RPM Fusion's NVIDIA page for the current package name.
- **Wayland:** `cat /sys/module/nvidia_drm/parameters/modeset` should print `Y`.

## 2. Adding NVIDIA modules to the dracut configuration

Fedora uses dracut instead of mkinitcpio. The equivalent of mkinitcpio's `MODULES=` is a drop-in config file:

```
sudo tee /etc/dracut.conf.d/nvidia.conf <<'EOF'
add_drivers+=" nvidia nvidia_modeset nvidia_uvm nvidia_drm "
EOF
```

Keep the spaces inside the quotes, because dracut concatenates these values and they break without them.

Rebuild and verify:

```
sudo dracut --force --regenerate-all
lsinitrd | grep -i nvidia
```

### Related settings

- **DRM modeset (needed for Wayland):** `sudo grubby --update-kernel=ALL --args="nvidia-drm.modeset=1"`. RPM Fusion packages usually set this already, so check the sysfs value above first.
- **Block nouveau in the initramfs:** add `omit_drivers+=" nouveau "` to the same file. RPM Fusion normally blacklists it, so this is only a safeguard.

### Caveats

- Early loading is usually optional on Fedora. It mainly helps with early-boot graphics (Plymouth, LUKS prompt).
- If you plan single-GPU passthrough, do not also add `vfio-pci` to the initramfs for the same card, because the two will fight over it.
- The config file persists across kernel updates, and akmods plus dracut rebuild automatically.

## 3. Hiding the GRUB menu

Fedora already hides GRUB by default on single-OS installs. Check the current state first:

```
grep -E 'TIMEOUT|MENU' /etc/default/grub
sudo grub2-editenv list
```

To hide the menu, edit `/etc/default/grub` and set:

```
GRUB_TIMEOUT=0
GRUB_TIMEOUT_STYLE=hidden
```

Then regenerate the config:

- **UEFI (Fedora 34 and later):** `sudo grub2-mkconfig -o /etc/grub2.cfg`
- **Legacy BIOS:** `sudo grub2-mkconfig -o /boot/grub2/grub.cfg`

On UEFI, `/etc/grub2.cfg` is a symlink to the right file, so do not point it at `/boot/efi/...` on modern Fedora.

### Notes

- With `GRUB_TIMEOUT_STYLE=hidden` and a nonzero timeout such as `GRUB_TIMEOUT=2`, nothing is shown, but you can hold Shift or tap Esc during that window to get the menu. With `0` that window is gone.
- Fedora's boot-success flag shows the menu only after a failed boot. To toggle it: `sudo grub2-editenv - unset menu_auto_hide` (always show) or `sudo grub2-editenv - set menu_auto_hide=1` (auto-hide).
- **Recovery:** if you cannot get into the menu, boot a live USB, or tap Esc repeatedly right after the firmware logo.
- **Dual-boot with Windows:** you lose the easy OS picker. Use the firmware boot menu (F12, F8, or Esc) or keep a short timeout like 2 seconds.

## 4. Btrfs snapshots with Snapper

Fedora installs on Btrfs by default, so Snapper is the usual route.

1. **Check your layout:** `findmnt -no FSTYPE /` should print `btrfs`, and `sudo btrfs subvolume list /` should show `root` and `home`.
2. **Install:**

```
sudo dnf install snapper python3-dnf-plugin-snapper btrfs-assistant
```

The DNF plugin takes pre and post snapshots around every package transaction. `btrfs-assistant` is an optional GUI for browsing and restoring snapshots.

3. **Create configs:**

```
sudo snapper -c root create-config /
sudo snapper -c home create-config /home
```

4. **Set retention** in `/etc/snapper/configs/root` (the defaults are too generous):

```
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="2"
TIMELINE_LIMIT_MONTHLY="1"
TIMELINE_LIMIT_YEARLY="0"
```

5. **Enable the timers:**

```
sudo systemctl enable --now snapper-timeline.timer snapper-cleanup.timer
```

6. **Test:** `sudo snapper -c root create -d "test"`, then `snapper -c root list`.

### Restoring

- **Undo changes to files:** `sudo snapper -c root status 5..6`, then `sudo snapper -c root undochange 5..6`.
- **Single files:** copy them out of `/.snapshots/<N>/snapshot/`.
- **Full rollback:** Fedora's layout (a plain `root` subvolume) does not support `snapper rollback` as cleanly as openSUSE does. The simplest approach is to boot a live USB, mount the top-level subvolume, rename `root`, and snapshot the old one into place. Booting from snapshots in GRUB needs `grub-btrfs`, which is not in Fedora's main repos.

### Caveats

- **Snapshots are not backups.** They live on the same disk, so pair them with `btrfs send` or another backup tool.
- **VM disk images:** snapshotting large, constantly changing images bloats quickly. Put them in their own subvolume (or a directory with `chattr +C`, set before files are created) and keep it out of the snapshotted subvolumes.
- **`/boot` is ext4** on default Fedora, so snapshots do not cover kernels and the GRUB config.
- **Space:** check usage with `sudo btrfs filesystem usage /` and do not let the disk fill up.
