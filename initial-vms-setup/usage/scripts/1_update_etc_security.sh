#!/usr/bin/env bash
set -euo pipefail

CHROOT_CONF=/etc/security/chroot.conf

chroot_user_to_home() {
  local entry
  entry="$(printf "%s\t\t\t/home/%s" "$1" "$1")"
  grep -qxF "$entry" "$CHROOT_CONF" || echo "$entry" >> "$CHROOT_CONF"
}

main() {
  chroot_user_to_home "$1"
}

main "$@"
