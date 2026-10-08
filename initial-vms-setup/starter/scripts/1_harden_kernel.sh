#!/bin/bash
set -euo pipefail

conf_dir="$(dirname "$0")/../conf"

# === start 1
# a) install_sysctl_hardening
install -m 644 "$conf_dir/90-qubes-hardening.conf" /etc/sysctl.d/90-qubes-hardening.conf
# b) apply_sysctl_settings
sysctl --system > /dev/null

# === end 1
# === start 2
# a) lock_module_loading
echo 1 > /proc/sys/kernel/modules_disabled
# === end 2

echo "done."
