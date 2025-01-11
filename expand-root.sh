# Configure startup scripts
cat << "EOF" > /etc/uci-defaults/70-rootpt-resize
if [ ! -e /etc/rootpt-resize ] \
&& type parted > /dev/null \
&& lock -n /var/lock/root-resize
then
ROOT_BLK="$(readlink -f /sys/dev/block/"$(awk -e \
'$9=="/dev/root"{print $3}' /proc/self/mountinfo)")"
ROOT_DISK="/dev/$(basename "${ROOT_BLK%/*}")"
ROOT_PART="${ROOT_BLK##*[^0-9]}"
OLD_PARTUUID=$(blkid -s PARTUUID -o value ${ROOT_DISK}p2)
parted -f -s "${ROOT_DISK}" \
resizepart "${ROOT_PART}" 5GB
mount_root done
NEW_PARTUUID=$(blkid -s PARTUUID -o value ${ROOT_DISK}p2)
BOOT_PARTITION="/boot"
CMDLINE_FILE="${BOOT_PARTITION}/cmdline.txt"
PARTUUID_FILE="${BOOT_PARTITION}/partuuid.txt"
sed -i "s/PARTUUID=$OLD_PARTUUID/PARTUUID=$NEW_PARTUUID/" "$CMDLINE_FILE"
BASE_PARTUUID=$(echo "$NEW_PARTUUID" | sed 's/-.*//')
echo "$BASE_PARTUUID" > "$PARTUUID_FILE"
touch /etc/rootpt-resize
reboot
fi
exit 1
EOF
cat << "EOF" > /etc/uci-defaults/80-rootfs-resize
if [ ! -e /etc/rootfs-resize ] \
&& [ -e /etc/rootpt-resize ] \
&& type losetup > /dev/null \
&& type resize2fs > /dev/null \
&& lock -n /var/lock/root-resize
then
ROOT_BLK="$(readlink -f /sys/dev/block/"$(awk -e \
'$9=="/dev/root"{print $3}' /proc/self/mountinfo)")"
ROOT_DEV="/dev/${ROOT_BLK##*/}"
LOOP_DEV="$(awk -e '$5=="/overlay"{print $9}' \
/proc/self/mountinfo)"
if [ -z "${LOOP_DEV}" ]
then
LOOP_DEV="$(losetup -f)"
losetup "${LOOP_DEV}" "${ROOT_DEV}"
fi
resize2fs -f "${LOOP_DEV}"
mount_root done
touch /etc/rootfs-resize
reboot
fi
exit 1
EOF
cat << "EOF" >> /etc/sysupgrade.conf
/etc/uci-defaults/70-rootpt-resize
/etc/uci-defaults/80-rootfs-resize
EOF