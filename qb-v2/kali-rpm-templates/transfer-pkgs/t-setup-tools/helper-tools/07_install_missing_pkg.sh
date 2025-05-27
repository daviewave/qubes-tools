#!/bin/bash

echo "(7/8) adding 'lintian package and updating'"

sudo apt --fix-broken install lintian
./update.sh fix
./restart_services.sh

echo "(7/8) done."
