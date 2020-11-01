#!/bin/bash -e

sudo apt update && sudo apt upgrade

TMP_DIR=$(mktemp -d)
pushd ${TMP_DIR}
wget https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered -O install-node-red.sh
chmod +x install-node-red.sh
./install-node-red.sh --confirm-install --confirm-pi
popd
rm -rf ${TMP_DIR}

# Copy initial node-red folder to node-red user
sudo -u node-red rsync -avz ${HOME}/.node-red /opt/node-red

# Remove local node-red folder
rm -rf ${HOME}/.node-red

# Fix systemd service user & group
sudo systemctl stop nodered.service
sudo sed -i -e 's/^User=.*$/User=node-red/' -e 's/^Group=.*$/Group=node-red/' -e 's/^WorkingDirectory=.*$/WorkingDirectory=\/opt\/node-red/' /lib/systemd/system/nodered.service
sudo systemctl daemon-reload

# Enable nodered after booting
sudo systemctl enable nodered.service

# Start nodered
sudo systemctl start nodered.service
