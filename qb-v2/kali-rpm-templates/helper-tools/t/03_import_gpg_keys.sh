#!/bin/bash

# shellcheck source=envs.sh
. "$(dirname "${BASH_SOURCE[0]}")/envs.sh"

# === start 1
# a) proxy_gpg_key_fetch
function proxy_gpg_key_fetch(){
  key_id="$1"
  key_file="${key_id}.asc"
  search_url="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${key_id}"
  wget $search_url -e use_proxy=on -e https_proxy=$https_proxy -O ./$key_file
  gpg --import ./$key_file
  gpg --edit-key $key_id
  sudo mv "$key_file" "$trusted_gpgs/"
}
# === end 1

echo "(3/6) adding qubes master key, release signing key (4.3), & debian pkgs signing key..."
# === start 2

# a) trust_qubes_master_key
gpg --import "${qmsk_fp}"
gpg --edit-key "${qmsk_id}" #(trust 5)

# b) install_qubes_release_key_as_apt_keyring
sudo rm "${archive_keyring}/qubes-archive-keyring.gpg" || true
proxy_gpg_key_fetch $qrsk
sudo sed -i 's|qubes-archive-keyring-4.3.gpg|qubes-archive-keyring.gpg|g' "${srcs_lists}/qubes-r4.list"
sudo rm "${archive_keyring}/qubes-archive-keyring.gpg" || true
gpg --export $qrsk | sudo tee "${archive_keyring}/qubes-archive-keyring.gpg" > /dev/null

# c) import_qubes_debian_key
proxy_gpg_key_fetch $qdsk

# d) update_fixing_broken
sudo bash "${qbpht}/update.sh" fix
# === end 2

echo "(3/6) done."
