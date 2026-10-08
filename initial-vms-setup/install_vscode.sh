#!/bin/bash
set -euo pipefail
. "$(dirname "$0")/lib/common.sh"

install_on_fedora(){
  local key
  key=$(mktemp)
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc -o "$key"
  sudo rpm --import "$key"
  rm -f "$key"

  sudo tee /etc/yum.repos.d/vscode.repo > /dev/null <<'REPO'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
REPO

  sudo dnf install -y code
}

install_on_debian(){
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
  sudo chmod 644 /usr/share/keyrings/microsoft.gpg

  echo "deb [arch=$( dpkg --print-architecture ) signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

  sudo apt update
  sudo apt install -y code
}

os=$(resolve_os "${1:-}")
use_updates_proxy_if_template
"install_on_$os"
