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

2. Use `rpi-imager` to write image to SD card. The images are created under `deploy/`.