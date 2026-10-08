#!/bin/bash

fix=$1

# === start 1
# a) refresh_package_lists
echo "updating & upgrading..."
# b) upgrade_fixing_broken_if_asked

sudo apt update -y
if [[ "$fix" == "fix" ]]; then
  sudo apt --fix-broken upgrade -y
else
# === end 1
  sudo apt upgrade -y
fi

echo "done."
