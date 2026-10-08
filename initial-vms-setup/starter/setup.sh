#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  "$SCRIPT_DIR/scripts/1_harden_kernel.sh"
  "$SCRIPT_DIR/scripts/2_blacklist_mods.sh"
  "$SCRIPT_DIR/scripts/3_update_etc_security.sh"
  "$SCRIPT_DIR/scripts/4_reduce_sebool_bloat.sh"
  echo "done. check the result with: $SCRIPT_DIR/verify.sh"
}

main "$@"
