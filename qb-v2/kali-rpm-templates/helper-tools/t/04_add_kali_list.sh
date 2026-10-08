#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=envs.sh
. "$SCRIPT_DIR/envs.sh"

KALI_KEYRING_URL="https://archive.kali.org/archive-keyring.gpg"
KALI_KEYRING="kali-archive-keyring.gpg"
KALI_SUITES="https://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware"

install_proxychains_config() {
  sudo rm -rf /etc/proxychains4.conf
  sudo cp "$st/config/proxychains.conf" /etc
}

fetch_kali_archive_keyring() {
  sudo proxychains4 wget "$KALI_KEYRING_URL" -O "$archive_keyring/$KALI_KEYRING"
}

add_kali_source_list() {
  echo "deb [signed-by=$archive_keyring/$KALI_KEYRING] $KALI_SUITES" \
    | sudo tee "$srcs_lists/kali.list" > /dev/null
}

main() {
  echo "(4/6) adding kali gpg key and repo source...."
  install_proxychains_config
  fetch_kali_archive_keyring
  add_kali_source_list
  echo "(4/6) done."
}

main "$@"
