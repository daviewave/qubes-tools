#!/bin/bash

./check_env.sh
if [ $? -eq 1 ]; then
  exit 1
fi

function proxy_gpg_key_fetch(){
  key_id="$1"
  key_file="${key_id}.asc"
  search_url="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${key_id}"
  wget $search_url -e use_proxy=on -e https_proxy=$https_proxy -O ./$key_file
  gpg --import ./$key_file
  gpg --edit-key $key_id
  mv $key_file $trusted_gpgs
}

echo "(3/6) adding qubes master key, release signing key (4.3), & debian pkgs signing key..."

#-a-> qubes master sk
gpg --import "${qmsk_fp}"
gpg --edit-key "${qmsk_id}" #(trust 5)

#-b-> qubes release sk
sudo rm "${archive_keyring}/qubes-archive-keyring.gpg" || true
proxy_gpg_key_fetch $qrsk
sudo sed -i 's|qubes-archive-keyring-4.3.gpg|qubes-archive-keyring.gpg|g' "${src_lists}/qubes-r4.list"
sudo rm "${archive_keyring}/qubes-archive-keyring.gpg" || true
gpg --export $qrsk | sudo tee "${archive_keyring}/qubes-archive-keyring.gpg" > /dev/null

#-c-> qubes debian sk
proxy_gpg_key_fetch $qdsk

sudo bash "${qbpht}/update.sh" fix

echo "(3/6) done."
