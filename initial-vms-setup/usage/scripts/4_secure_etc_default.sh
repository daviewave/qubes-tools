#!/bin/bash

# === start 1
# a) remove_unneeded_defaults
rm -f /etc/default/useradd /etc/default/grub.qubes-kernel-vm-support /etc/default/pcscd

# b) write_grub_qubes_defaults
line1="GRUB_DEVICE=/dev/mapper/dmroot"
line2="GRUB_DISABLE_LINUX_UUID=true"
line3="GRUB_DISABLE_OS_PROBER=true"
line4='GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX root=/dev/mapper/dmroot console=tty0 noresume"'
line5="GRUB_TIMEOUT=0"

echo -e "$line1 \n$line2 \n$line3 \n$line4 \n$line5" > /etc/default/grub.qubes
# === end 1
