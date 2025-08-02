#!/bin/bash

os=$1

install_on_fedora(){
  sudo dnf config-manager addrepo --from-repofile=https://repository.mullvad.net/rpm/stable/mullvad.repo
  sudo dnf install mullvad-browser
}

install_on_debian(){
  sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc
  echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$( dpkg --print-architecture )] https://repository.mullvad.net/deb/stable stable main" | sudo tee /etc/apt/sources.list.d/mullvad.list
  sudo apt update
  sudo apt install mullvad-vpn
}

if [[ -z "$os" || "$os" == "fedora"  ]]; then
  install_on_fedora
else
  install_on_debian
fi

