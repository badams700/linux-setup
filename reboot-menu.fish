#!/usr/bin/env fish
# KDE reboot selector with three buttons: Reboot, Windows, CachyOS EAC kernel.
# Requires: zenity, efibootmgr, pkexec (polkit), systemd-boot.

# --switch removes the default OK/Cancel buttons, so only our 3 buttons show.
# Clicking one prints its label to stdout; closing the window prints nothing.
set choice (zenity --question --title "Reboot Into..." \
    --text "Choose where to reboot:" \
    --switch \
    --extra-button "Reboot" \
    --extra-button "Windows" \
    --extra-button "CachyOS EAC")

test -z "$choice"; and exit 0 # window closed -> do nothing

switch $choice
    case "Reboot"
        systemctl reboot
        or zenity --error --text "Failed to reboot."

    case "Windows"
        # Find the Windows Boot Manager entry number (e.g. 0000)
        set bootnum (efibootmgr 2>/dev/null \
            | string match -rg '^Boot([0-9A-Fa-f]{4})\*? Windows Boot Manager' \
            | head -n1)

        if test -z "$bootnum"
            zenity --error --text "Couldn't find a 'Windows Boot Manager' entry in efibootmgr."
            exit 1
        end

        if pkexec efibootmgr --bootnext $bootnum >/dev/null
            systemctl reboot
        else
            zenity --error --text "Failed to set BootNext to Boot$bootnum."
            exit 1
        end

    case "CachyOS EAC"
        systemctl reboot --boot-loader-entry=cachyos-eac.conf
        or zenity --error --text "Failed to reboot into cachyos-eac.conf."
end
