#!/bin/bash

# shellcheck source=envs.sh
. "$(dirname "${BASH_SOURCE[0]}")/envs.sh"

# === start 1
# a) clear_qubes_incoming
rm -rf /home/user/QubesIncoming

echo "(2/6) adding custom tools..."

# b) install_custom_tools_into_builder
cd "$st" || exit 1
cp builders/curr.yml "${qbp}/builder.yml" 
chmod +x "${stht}"/*
mkdir -p "${qbpht}"
cp -rT "${stht}" "${qbpht}"
mv "${qbpht}/generate-container-image.sh" "${qbp}/tools/"

# c) install_proxy_tools
sudo apt install -y wget proxychains4
# === end 1

echo "(2/6) done."

