#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=envs.sh
. "$SCRIPT_DIR/envs.sh"

is_qubes_vm() {
  [ -f /usr/share/qubes/marker-vm ]
}

install_builder_dependencies() {
  sudo apt upgrade gnupg
  sudo apt --fix-broken install lintian
  xargs -a "$qbp/dependencies-debian.txt" sudo apt install -y
  if is_qubes_vm; then
    sudo apt install qubes-gpg-split
  fi
}

init_builder_submodules() {
  git -C "$qbp" submodule update --init
}

generate_user_gpg_key() {
  gpg --full-generate-key
}

update_and_restart_services() {
  "$stht/update.sh" fix
  "$stht/restart_services.sh"
}

main() {
  echo "(6/6) installing dependencies & git submodules..."
  install_builder_dependencies
  init_builder_submodules
  generate_user_gpg_key
  update_and_restart_services
  echo "(6/6) done."
}

main "$@"
