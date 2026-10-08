#!/bin/bash

./check_env.sh
if [ $? -eq 1 ]; then
  exit 1
fi

echo "(6/6) installing dependencies & git submodules..."

cd "$qbp" || exit 1
sudo apt upgrade gnupg
sudo apt --fix-broken install lintian
xargs -a dependencies-debian.txt sudo apt install -y
test -f /usr/share/qubes/marker-vm && sudo apt install qubes-gpg-split
git submodule update --init

gpg --full-generate-key

"${stht}/update.sh" fix
"${stht}/restart_services.sh"

echo "(6/6) done."
