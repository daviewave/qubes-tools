#!/bin/bash
set -euo pipefail

conf_dir="$(dirname "$0")/../conf"

# === start 1
# a) install_module_blacklist
install -m 644 "$conf_dir/blacklist.conf" /etc/modprobe.d/blacklist.conf

# b) regenerate_initramfs
if command -v dracut > /dev/null; then
  dracut -f
elif command -v update-initramfs > /dev/null; then
  update-initramfs -u
fi
# === end 1

echo "done."
