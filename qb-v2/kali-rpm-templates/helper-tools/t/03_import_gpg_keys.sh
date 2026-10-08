#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=envs.sh
. "$SCRIPT_DIR/envs.sh"

KEYSERVER_LOOKUP="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x"
QUBES_KEYRING="qubes-archive-keyring.gpg"

die() {
  echo "$*" >&2
  exit 1
}

fingerprint_of() {
  gpg --with-colons --fingerprint "$1" | awk -F: '/^fpr:/ {print $10; exit}'
}

trust_ultimately() {
  printf '%s:6:\n' "$(fingerprint_of "$1")" | gpg --import-ownertrust
}

signed_by_master_key() {
  gpg --check-sigs --with-colons "$1" | grep -q "^sig:!:[^:]*:[^:]*:${qmsk_id: -16}:"
}

require_signed_by_master_key() {
  signed_by_master_key "$1" || die "key $1 carries no valid signature from the qubes master key, refusing to trust it"
}

proxy_gpg_key_fetch() {
  local key_id=$1
  local key_file="$1.asc"
  wget "$KEYSERVER_LOOKUP$key_id" -e use_proxy=on -e "https_proxy=$https_proxy" -O "./$key_file"
  gpg --import "./$key_file"
  sudo mv "$key_file" "$trusted_gpgs/"
}

trust_qubes_master_key() {
  gpg --import "$qmsk_fp"
  trust_ultimately "$qmsk_id"
}

install_qubes_release_key_as_apt_keyring() {
  proxy_gpg_key_fetch "$qrsk"
  require_signed_by_master_key "$qrsk"
  trust_ultimately "$qrsk"
  sudo sed -i "s|qubes-archive-keyring-4.3.gpg|$QUBES_KEYRING|g" "$srcs_lists/qubes-r4.list"
  sudo rm -f "$archive_keyring/$QUBES_KEYRING"
  gpg --export "$qrsk" | sudo tee "$archive_keyring/$QUBES_KEYRING" > /dev/null
}

import_qubes_debian_key() {
  proxy_gpg_key_fetch "$qdsk"
  trust_ultimately "$qdsk"
}

update_fixing_broken() {
  "$stht/update.sh" fix
}

main() {
  echo "(3/6) adding qubes master key, release signing key (4.3), & debian pkgs signing key..."
  trust_qubes_master_key
  install_qubes_release_key_as_apt_keyring
  import_qubes_debian_key
  update_fixing_broken
  echo "(3/6) done."
}

main "$@"
