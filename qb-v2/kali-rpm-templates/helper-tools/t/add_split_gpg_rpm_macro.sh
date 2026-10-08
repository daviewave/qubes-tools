#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=envs.sh
. "$SCRIPT_DIR/envs.sh"

install_split_gpg_rpm_macros() {
  cat "$st/config/split-sign-macros.conf" > /home/user/.rpmmacros
}

main() {
  install_split_gpg_rpm_macros
}

main "$@"
