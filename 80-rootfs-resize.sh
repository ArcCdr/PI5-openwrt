if [ ! -e /etc/rootfs-resize ] && [ -e /etc/rootpt-resize ] && type losetup >/dev/null && type resize2fs >/dev/null && lock -n /var/lock/root-resize; then
    ROOT_BLK="$(readlink -f /sys/dev/block/"$(awk -e '$9=="/dev/root"{print $3}' /proc/self/mountinfo)")"
    ROOT_DEV="/dev/${ROOT_BLK##*/}"
    LOOP_DEV="$(awk -e '$5=="/overlay"{print $9}' /proc/self/mountinfo)"
    if [ -z "${LOOP_DEV}" ]; then
        LOOP_DEV="$(losetup -f)"
        losetup "${LOOP_DEV}" "${ROOT_DEV}"
    fi
    resize2fs -f "${LOOP_DEV}"
    mount_root done
    touch /etc/rootfs-resize
    reboot
fi
exit 1
