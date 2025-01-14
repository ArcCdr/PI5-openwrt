parted /dev/mmcblk0 mkpart primary ext4 5001MB 100%
mkfs.ext4 /dev/mmcblk0p3
mkdir /mnt/data
uci add fstab mount
uci set fstab.@mount[-1].target='/mnt/data'
uci set fstab.@mount[-1].device='/dev/mmcblk0p3'
uci set fstab.@mount[-1].fstype='ext4'
uci set fstab.@mount[-1].enabled='1'
uci commit fstab
/etc/init.d/fstab enable
/etc/init.d/fstab start

