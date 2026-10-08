#!/bin/bash

entry=$(printf "%s\t\t\t/home/%s" "$1" "$1")
grep -qxF "$entry" /etc/security/chroot.conf || echo "$entry" >> /etc/security/chroot.conf
#echo -e "$2\t\t\t/home/$2"
