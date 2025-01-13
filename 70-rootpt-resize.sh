# Check prerequisites
if [ ! -e /etc/rootpt-resize ] && type parted >/dev/null && lock -n /var/lock/root-resize; then

    # Identifies root partition
    ROOT_BLK="$(readlink -f /sys/dev/block/"$(awk -e '$9=="/dev/root"{print $3}' /proc/self/mountinfo)")"
    ROOT_DISK="/dev/$(basename "${ROOT_BLK%/*}")"
    ROOT_PART="${ROOT_BLK##*[^0-9]}"
    OLD_PARTUUID=$(blkid -s PARTUUID -o value ${ROOT_DISK}p${ROOT_PART})
    echo "Existing root partition's UUID: '$OLD_PARTUUID'."

    # Resizes root partition
    parted -f -s "${ROOT_DISK}" resizepart "${ROOT_PART}" 5GB
    sleep 1
    NEW_PARTUUID=$(blkid -s PARTUUID -o value ${ROOT_DISK}p${ROOT_PART})
    echo "New root partition's UUID (after resize): '$NEW_PARTUUID'."

    # Update Raspberry Pi bootloader config
    BOOT_PARTITION="/boot"
    CMDLINE_FILE="${BOOT_PARTITION}/cmdline.txt"
    PARTUUID_FILE="${BOOT_PARTITION}/partuuid.txt"
    sed -i "s/PARTUUID=$OLD_PARTUUID/PARTUUID=$NEW_PARTUUID/" "$CMDLINE_FILE"
    BASE_PARTUUID=$(echo "$NEW_PARTUUID" | sed 's/-.*//')
    echo "$BASE_PARTUUID" >"$PARTUUID_FILE"

    # Mark as done
    mount_root done
    touch /etc/rootpt-resize
    # reboot
fi

exit 1
