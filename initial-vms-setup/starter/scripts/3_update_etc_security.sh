#!/bin/bash
set -euo pipefail

cfg_dir=/etc/security

echo "-:ALL:ALL" > $cfg_dir/access.conf

grep -qx "audit" $cfg_dir/faillock.conf || echo "audit" >> $cfg_dir/faillock.conf

echo "done."
