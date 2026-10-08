#!/bin/bash

# shellcheck source=envs.sh
. "$(dirname "${BASH_SOURCE[0]}")/envs.sh"

echo "(5/6) major update & upgrade (~1500 pkgs)..."

# === start 1
# a) upgrade_gnupg_and_lintian
sudo apt upgrade gnupg
sudo apt --fix-broken install lintian
# b) update_and_restart_services
"${stht}/update.sh" fix
"${stht}/restart_services.sh"
# === end 1

echo "(5/6) done."

