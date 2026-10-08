#!/bin/bash
set -euo pipefail

cfg_dir=/etc/security

# === start 1
# a) deny_all_pam_access
echo "-:ALL:ALL" > $cfg_dir/access.conf

# b) audit_faillock
grep -qx "audit" $cfg_dir/faillock.conf || echo "audit" >> $cfg_dir/faillock.conf
# === end 1

echo "done."
