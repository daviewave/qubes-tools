#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_DIR="$SCRIPT_DIR/../conf"

install_module_blacklist() {
  install -m 644 "$CONF_DIR/blacklist.conf" /etc/modprobe.d/blacklist.conf
}

regenerate_initramfs() {
  if command -v dracut > /dev/null; then
    dracut -f
  elif command -v update-initramfs > /dev/null; then
    update-initramfs -u
  fi
}

main() {
  install_module_blacklist
  regenerate_initramfs
  echo "done."
}

main "$@"
