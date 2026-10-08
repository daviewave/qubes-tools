#!/bin/bash

# shellcheck source=envs.sh
. "$(dirname "${BASH_SOURCE[0]}")/envs.sh"

echo "(6/6) installing dependencies & git submodules..."

# === start 1
# a) install_builder_dependencies
cd "$qbp" || exit 1
sudo apt upgrade gnupg
sudo apt --fix-broken install lintian
xargs -a dependencies-debian.txt sudo apt install -y
test -f /usr/share/qubes/marker-vm && sudo apt install qubes-gpg-split
# b) init_builder_submodules
git submodule update --init

# c) generate_user_gpg_key
gpg --full-generate-key

# d) update_and_restart_services
"${stht}/update.sh" fix
"${stht}/restart_services.sh"
# === end 1

echo "(6/6) done."
