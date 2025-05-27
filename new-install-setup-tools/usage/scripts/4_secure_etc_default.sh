#!/bin/bash

cd /etc/default

rm useradd grub.qubes-kernel-vm-support pcscd

line1="GRUB_DEVICE=/dev/mapper/dmroot"
line2="GRUB_DISABLE_LINUX_UUID=true"
line3="GRUB_DISABLE_OS_PROBER=true"
line4='GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX root=/dev/mapper/dmroot/ console=tty0 noresume"'
line5="GRUB_TIMEOUT=0"

echo -e "$line1 \n$line2 \n$line3 \n$line4 \n$line5" > /etc/default/grub.qubes
