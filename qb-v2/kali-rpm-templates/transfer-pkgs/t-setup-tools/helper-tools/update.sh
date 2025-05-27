#!/bin/bash

fix=$1

echo "updating & upgrading..."

sudo apt update -y
if [[ ! -e "$fix" ]]; then
  sudo apt --fix-broken upgrade -y
else
  sudo apt upgrade -y
fi

echo "done."
