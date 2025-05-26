#!/bin/bash

./check_env.sh
if [ $? -eq 1 ]; then
  exit 1
fi

echo "(5/6) major update & upgrade (~1500 pkgs)..."

./update.sh fix
./restart_services.sh

echo "(5/6) done."

