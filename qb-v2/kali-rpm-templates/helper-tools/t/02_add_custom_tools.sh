#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=envs.sh
. "$SCRIPT_DIR/envs.sh"

clear_qubes_incoming() {
  rm -rf /home/user/QubesIncoming
}

install_custom_tools_into_builder() {
  cp "$st/builders/curr.yml" "$qbp/builder.yml"
  chmod +x "$stht"/*
  mkdir -p "$qbpht"
  cp -rT "$stht" "$qbpht"
  mv "$qbpht/generate-container-image.sh" "$qbp/tools/"
}

install_proxy_tools() {
  sudo apt install -y wget proxychains4
}

main() {
  clear_qubes_incoming
  echo "(2/6) adding custom tools..."
  install_custom_tools_into_builder
  install_proxy_tools
  echo "(2/6) done."
}

main "$@"
