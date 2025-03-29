#!/bin/bash

e="/etc"

# 1. remove remote and unused packages
rmv_pkgs="rmt openssh amd-gpu-firmware amd-ucode-firmware libdav1d lvm2"
sudo dnf remove --noautoremove $rmv_pkgs

# 2. remove remote connection configurations
rmv_cfgs="$e/ssh $e/crypto-policies/back-ends/ $e/libssh $e/lvm $e/host.conf $e/krb*"
sudo rm -rf $rmv_cfgs

sudo sed -i "s|sss||g" /etc/nsswitch.conf
sudo sed -i "s|sss||g" /etc/authselect/nsswitch.conf
sudo sed -i "s|sssd||g" /etc/authselect/authselect.conf
sudo sed -i "s|with-silent-lastlog||g" /etc/authselect/authselect.conf
sudo sed -i "s|EnableLogging=0|EnableLogging=1|g" /etc/usb_modeswitch.conf



# requires manual write to file
# sudo echo -e "127.0.0.1\tlocalhost \n::1\tlocalhost6" > /etc/host
