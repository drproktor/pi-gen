#!/bin/bash -e

on_chroot << EOF
groupadd -f -r gpio
usermod -a -G gpio $FIRST_USER_NAME
EOF

install -m 644 files/99-gpio-udev.rules "${ROOTFS_DIR}/etc/udev/rules.d/"
