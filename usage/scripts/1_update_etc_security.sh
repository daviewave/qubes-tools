#!/bin/bash

cfg_dir=/etc/security

echo -e "$1\t\t\t/home/$1" >> /etc/security/chroot.conf
#echo -e "$2\t\t\t/home/$2" >> /etc/security/chroot.conf

echo "done."
