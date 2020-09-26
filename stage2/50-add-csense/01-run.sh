#!/bin/bash -e

# Add node-red user with default password
on_chroot << EOF
if ! id -u node-red >/dev/null 2>&1; then
	adduser --system \
			--group \
			--disabled-password \
			--gecos "User for Node RED" \
			--home /home/node-red \
			node-red
fi
pushd /home/node-red
/bin/bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
systemctl enable nodered.service
popd
EOF
