#!/bin/bash

echo "(8/8) installing dependencies & git submodules..."

cd /opt/qubes-builderv2
sudo apt install $(cat dependencies-debian.txt)
test -f /usr/share/qubes/marker-vm && sudo apt install qubes-gpg-split
git submodule update --init

./update.sh fix
./restart_services.sh

echo "(8/8) done."
