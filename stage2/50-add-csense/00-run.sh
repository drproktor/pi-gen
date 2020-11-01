#!/bin/bash -e

on_chroot << EOF
groupadd -f -r gpio
usermod -a -G gpio $FIRST_USER_NAME
EOF

install -m 644 files/99-gpio-udev.rules "${ROOTFS_DIR}/etc/udev/rules.d/"

# Note: Installing Node RED with this user in the chroot, does not work 
# out of the box. As workaround we prepare everything such that we can
# install with one command on first login.

# Add node-red user without password
on_chroot << EOF
if ! id -u node-red >/dev/null 2>&1; then
	adduser --disabled-password \
			--gecos "User for Node RED" \
			--home /opt/node-red \
            node-red
fi
EOF

# Add download script for node-red
install -m 644 files/install-and-setup-node-red.sh "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"
on_chroot << EOF
chmod +x /home/${FIRST_USER_NAME}/install-and-setup-node-red.sh
chown ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/install-and-setup-node-red.sh
EOF

# install -m 644 files/resolv.conf "${ROOTFS_DIR}/etc/"
