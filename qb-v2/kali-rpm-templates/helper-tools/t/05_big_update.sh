#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=envs.sh
. "$SCRIPT_DIR/envs.sh"

upgrade_gnupg_and_lintian() {
  sudo apt upgrade gnupg
  sudo apt --fix-broken install lintian
}

update_and_restart_services() {
  "$stht/update.sh" fix
  "$stht/restart_services.sh"
}

main() {
  echo "(5/6) major update & upgrade (~1500 pkgs)..."
  upgrade_gnupg_and_lintian
  update_and_restart_services
  echo "(5/6) done."
}

main "$@"
