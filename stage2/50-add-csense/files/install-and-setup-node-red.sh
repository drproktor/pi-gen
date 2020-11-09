#!/bin/bash -e

sudo apt update && sudo apt upgrade --assume-yes

TMP_DIR=$(mktemp -d)
pushd ${TMP_DIR}
wget https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered -O install-node-red.sh
chmod +x install-node-red.sh
./install-node-red.sh --confirm-install --confirm-pi
popd
rm -rf ${TMP_DIR}

# Fix systemd service user & group
sudo systemctl stop nodered.service
sudo sed -i -e 's/^User=.*$/User=node-red/' -e 's/^Group=.*$/Group=node-red/' -e 's/^WorkingDirectory=.*$/WorkingDirectory=\/opt\/node-red/' /lib/systemd/system/nodered.service
sudo systemctl daemon-reload

# Enable nodered after booting
sudo systemctl enable nodered.service

# Start nodered
sudo systemctl start nodered.service

# Add github to known_hosts for Node-Red projects
sudo -u node-red mkdir -p opt/node-red/.ssh/
sudo -u node-red chmod 700 /opt/node-red/.ssh/
sudo -u node-red ssh-keyscan -H github.com >> /opt/node-red/.ssh/known_hosts
