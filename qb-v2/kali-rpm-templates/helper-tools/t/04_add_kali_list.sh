#!/bin/bash

# shellcheck source=envs.sh
. "$(dirname "${BASH_SOURCE[0]}")/envs.sh"

echo "(4/6) adding kali gpg key and repo source...."

# === start 1
# a) install_proxychains_config
sudo rm -rf /etc/proxychains4.conf
sudo cp "${st}/config/proxychains.conf" /etc

# b) fetch_kali_archive_keyring
sudo proxychains4 wget https://archive.kali.org/archive-keyring.gpg -O "${archive_keyring}/kali-archive-keyring.gpg"

# c) add_kali_source_list
echo "deb [signed-by=${archive_keyring}/kali-archive-keyring.gpg] https://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" \
  | sudo tee "${srcs_lists}/kali.list" > /dev/null
# === end 1

echo -e '\n(4/6) done. \n'
