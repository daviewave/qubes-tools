#!/bin/bash

# shellcheck source=envs.sh
. "$(dirname "${BASH_SOURCE[0]}")/envs.sh"

echo "(5/6) major update & upgrade (~1500 pkgs)..."

sudo apt upgrade gnupg
sudo apt --fix-broken install lintian
"${stht}/update.sh" fix
"${stht}/restart_services.sh"

echo "(5/6) done."

