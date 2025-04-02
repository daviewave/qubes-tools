#!/bin/bash

./scripts/1_harden_kernel.sh

./scripts/2_blacklist_mods.sh

./scripts/3_update_etc_security.sh

./scripts/4_reduce_sebool_bloat.sh

echo "done."
