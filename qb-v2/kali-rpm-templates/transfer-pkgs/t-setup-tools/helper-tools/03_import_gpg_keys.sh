#!/bin/bash

echo "(3/8) adding qubes master key, release signing key (4.3), & debian pkgs signing key..."

#-a
sudo rm /usr/share/keyrings/qubes-archive-keyring.gpg
gpg --import /usr/share/qubes/qubes-master-key.asc
gpg --edit-key 427F11FD0FAA4B080123F01CDDFA1A3E36879494 #(trust 5)
sudo sed -i 's|qubes-archive-keyring-4.3.gpg|qubes-archive-keyring.gpg|g' /etc/apt/sources.list.d/qubes-r4.list
sudo rm /usr/share/keyrings/qubes-archive-keyring.gpg || true
gpg --export 720415900AB8C804 | sudo tee /usr/share/keyrings/qubes-archive-keyring.gpg > /dev/null

#-b
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 720415900AB8C804
gpg --edit-key 720415900AB8C804 #(trust 5)

#-c
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys ED65462EC8D5E4C5
gpg --edit-key ED65462EC8D5E4C5 #(trust 5)

./update.sh fix

echo "(3/8) done."
