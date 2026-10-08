#!/bin/bash

# === start 1
# a) chroot_user_to_home
entry=$(printf "%s\t\t\t/home/%s" "$1" "$1")
grep -qxF "$entry" /etc/security/chroot.conf || echo "$entry" >> /etc/security/chroot.conf
# === end 1
#echo -e "$2\t\t\t/home/$2"
