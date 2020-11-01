#!/bin/bash -e

sudo apt update && sudo apt upgrade

TMP_DIR=$(mktemp -d)
pushd ${TMP_DIR}
wget https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered -O install-node-red.sh
chmod +x install-node-red.sh
./install-node-red.sh --confirm-install --confirm-pi
popd
rm -rf ${TMP_DIR}

sudo sed -i -e s/^User=.*$/User=node-red/ -e s/^Group=.*$/Group=node-red/ -e s/^WorkingDirectory=.*$/WorkingDirectory=\/opt\/node-red/ /lib/systemd/system/nodered.service
sudo systemctl enable nodered.service


