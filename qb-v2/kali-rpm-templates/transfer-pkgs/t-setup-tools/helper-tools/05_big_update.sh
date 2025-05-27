#!/bin/bash

echo "(5/8) major update & upgrade (~1500 pkgs)..."

./update.sh fix
./restart_services.sh

echo "(5/8) done."

