#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_DIR="$SCRIPT_DIR/../conf"
SYSCTL_CONF="90-qubes-hardening.conf"

install_sysctl_hardening() {
  install -m 644 "$CONF_DIR/$SYSCTL_CONF" "/etc/sysctl.d/$SYSCTL_CONF"
}

apply_sysctl_settings() {
  sysctl --system > /dev/null
}

lock_module_loading() {
  echo 1 > /proc/sys/kernel/modules_disabled
}

main() {
  install_sysctl_hardening
  apply_sysctl_settings
  lock_module_loading
  echo "done."
}

main "$@"
