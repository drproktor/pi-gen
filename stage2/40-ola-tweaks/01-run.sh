#!/bin/bash -e

# /dev/ttyAMA0 belongs to tty group
on_chroot << EOF
	usermod -a -G tty olad
EOF

# Copy OLA plugin config
install -d "${ROOTFS_DIR}/etc/ola/"
install -m 664 files/ola-uartdmx.conf "${ROOTFS_DIR}/etc/ola/"
# Default universe
install -m 664 files/ola-port.conf "${ROOTFS_DIR}/etc/ola/"
install -m 664 files/ola-universe.conf "${ROOTFS_DIR}/etc/ola/"
on_chroot << EOF
	chown -R olad:olad /etc/ola
EOF