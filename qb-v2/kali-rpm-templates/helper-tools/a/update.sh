#!/usr/bin/env bash
set -euo pipefail

refresh_package_lists() {
  sudo apt update -y
}

fix_requested() {
  [ "$1" = "fix" ]
}

upgrade_fixing_broken_if_asked() {
  if fix_requested "$1"; then
    sudo apt --fix-broken upgrade -y
  else
    sudo apt upgrade -y
  fi
}

main() {
  echo "updating & upgrading..."
  refresh_package_lists
  upgrade_fixing_broken_if_asked "${1:-}"
  echo "done."
}

main "$@"
