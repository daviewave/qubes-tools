#!/bin/bash
set -euo pipefail

conf_dir="$(dirname "$0")/../conf"

install -m 644 "$conf_dir/blacklist.conf" /etc/modprobe.d/blacklist.conf

if command -v dracut > /dev/null; then
  dracut -f
elif command -v update-initramfs > /dev/null; then
  update-initramfs -u
fi

echo "done."
