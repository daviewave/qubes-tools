#!/usr/bin/env bash
set -euo pipefail

CFG_DIR=/etc/security

deny_all_pam_access() {
  echo "-:ALL:ALL" > "$CFG_DIR/access.conf"
}

audit_faillock() {
  grep -qx "audit" "$CFG_DIR/faillock.conf" || echo "audit" >> "$CFG_DIR/faillock.conf"
}

main() {
  deny_all_pam_access
  audit_faillock
  echo "done."
}

main "$@"
