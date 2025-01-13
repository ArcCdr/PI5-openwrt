wget -O /etc/uci-defaults/70-rootpt-resize https://raw.githubusercontent.com/ArcCdr/PI5-openwrt/refs/heads/main/70-rootpt-resize.sh
wget -O /etc/uci-defaults/80-rootfs-resize https://raw.githubusercontent.com/ArcCdr/PI5-openwrt/refs/heads/main/80-rootfs-resize.sh
wget -O /etc/uci-defaults/85-customize https://raw.githubusercontent.com/ArcCdr/PI5-openwrt/refs/heads/main/85-customize.sh

cat << "EOF" >> /etc/sysupgrade.conf
/etc/uci-defaults/70-rootpt-resize
/etc/uci-defaults/80-rootfs-resize
/etc/uci-defaults/85-customize
EOF

sh /etc/uci-defaults/70-rootpt-resize
