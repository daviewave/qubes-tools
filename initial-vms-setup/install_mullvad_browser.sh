#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"

install_on_fedora(){
  if dnf --version 2>/dev/null | grep -q '^dnf5'; then
    sudo dnf config-manager addrepo --overwrite --from-repofile=https://repository.mullvad.net/rpm/stable/mullvad.repo
  else
    sudo dnf config-manager --add-repo https://repository.mullvad.net/rpm/stable/mullvad.repo
  fi
  sudo dnf install -y mullvad-browser
}

install_on_debian(){
  curl -fsSL https://repository.mullvad.net/deb/mullvad-keyring.asc | sudo tee /usr/share/keyrings/mullvad-keyring.asc > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$( dpkg --print-architecture )] https://repository.mullvad.net/deb/stable stable main" | sudo tee /etc/apt/sources.list.d/mullvad.list > /dev/null
  sudo apt update
  sudo apt install -y mullvad-browser
}

check_args() {
  [ "$#" -le 1 ] || os_usage
  resolve_os "${1:-}" > /dev/null
}

install_for() {
  "install_on_$1"
}

main() {
  check_args "$@"
  use_updates_proxy_if_template
  install_for "$(resolve_os "${1:-}")"
}

main "$@"
