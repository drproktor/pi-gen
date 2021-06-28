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
	usermod -a -G gpio,i2c node-red
fi
EOF

# Add download script for node-red
install -m 644 files/install-and-setup-node-red.sh "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"
on_chroot << EOF
chmod +x /home/${FIRST_USER_NAME}/install-and-setup-node-red.sh
chown ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/install-and-setup-node-red.sh
EOF

# Copy node-red files. Note this is simply a snapshot of the latest reference setup
cp -a files/node-red/ "${ROOTFS_DIR}/opt/node-red/"
on_chroot << EOF
mv /opt/node-red/node-red/ /opt/node-red/.node-red
chown -R node-red:node-red /opt/node-red/.node-red
EOF

# Enable i2c after boot. This is required in addition to the modification of /boot/config.txt
on_chroot << EOF
echo i2c-dev >> /etc/modules
EOF

# Copy csense
install -m 644 files/as73211-0.1.1-armhf.deb "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"
on_chroot << EOF
apt install /home/${FIRST_USER_NAME}/as73211-0.1.1-armhf.deb --yes
rm /home/${FIRST_USER_NAME}/as73211-0.1.1-armhf.deb
EOF

# Watchdog
install -m 644 files/watchdog.conf "${ROOTFS_DIR}/etc/"
on_chroot << EOF
ln -s /lib/systemd/system/watchdog.service /etc/systemd/system/multi-user.target.wants/
systemctl enable watchdog
EOF

if [ -f "files/default-ssids.txt" ]; then
    cat files/default-ssids.txt >> "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant.conf"
fi
