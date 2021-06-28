# How to create a new image

## Preparation

1. Copy current as73211 package to assets folder `stage2/50-add-csense/files/`:
```
cp <path to deb package>/as73211-0.1.1-armhf.deb stage2/50-add-csense/files/
```

2. Sync current node-red status to assets folder:
```
rsync -avz --exclude 'projects/.sshkeys/*' -e ssh --progress pi@rpi:/opt/node-red/.node-red/ node-red/
```
Note that we explicitly exclude the ssh keys here as these should be generated 
for every installation or added manually for security reasons.

## Build & burn

1. Run `./build-docker.sh`. In case any errors occur, try resuming with `CONTINUE=1 ./build-docker.sh`.

2. Use [rpi-imager](https://www.raspberrypi.org/software/) to write image to SD card. The images are created under `deploy/`.

## On-device configuration

1. Insert SD card into Raspberry Pi, boot, and login via ssh. The default user is `pi`,
   the default hostname is `raspberrypi`, and the default password for the `pi` user
   is `raspberry`. Use `passwd` to set a new password.

2. Hostname (Optional): Use `raspi-config` to change the hostname.

3. Wifi (Optional): Use `raspi-config` to set SSID and passphrase. `sudo raspi-config` under
   system settings.

3. On first login run the `./install-and-setup-node-red.sh` script located in the
   `$HOME` directory of the `pi` user. This scripts installs Node.js and adds
   Node RED. Upon installation Node RED will start automatically and it runs as
   `node-red` user. The Node RED folder is located at `/opt/node-red/.node-red/`.
   If you perform manual changes within this folder remember that all files need
   to be accessible by the `node-red` user. E.g. as `pi` user use 
   `sudo -u node-red bash` to create a sub-shell as `node-red` user.

4. Goto [http://raspberrypi.fritz.box:1880/admin/] and log in with username `admin` and
   password `as73211AMS`. Unfortunately this password can only be changed manually.
   The password hash can be created via `node-red admin hash-pw`. To change it add
   the hash to `settings.js` in `/opt/node-red/.node-red/settings.js` under `adminAuth`.

5. Development systems: Create an new ssh-key for git. Goto Settings -> Git Config.
   Add new key. Add key to repos allowed keys.

6. Goto the Node-Red project history tab, and pull in the latest changes by pulling in
   the changes in the commit history section. In case of warnings or errors just continue,
   no password is required.
