#!/bin/bash
set -euo pipefail

conf_dir="$(dirname "$0")/../conf"

install -m 644 "$conf_dir/90-qubes-hardening.conf" /etc/sysctl.d/90-qubes-hardening.conf
sysctl --system > /dev/null

echo 1 > /proc/sys/kernel/modules_disabled

echo "done."
