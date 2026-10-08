#!/usr/bin/env bash
set -euo pipefail

UNNEEDED_DEFAULTS="/etc/default/useradd /etc/default/grub.qubes-kernel-vm-support /etc/default/pcscd"

remove_unneeded_defaults() {
  # shellcheck disable=SC2086 # word-split the path list
  rm -f $UNNEEDED_DEFAULTS
}

write_grub_qubes_defaults() {
  # shellcheck disable=SC2016 # $GRUB_CMDLINE_LINUX is expanded by grub, not here
  printf '%s\n' \
    "GRUB_DEVICE=/dev/mapper/dmroot" \
    "GRUB_DISABLE_LINUX_UUID=true" \
    "GRUB_DISABLE_OS_PROBER=true" \
    'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX root=/dev/mapper/dmroot console=tty0 noresume"' \
    "GRUB_TIMEOUT=0" > /etc/default/grub.qubes
}

main() {
  remove_unneeded_defaults
  write_grub_qubes_defaults
}

main "$@"
