#!/bin/bash
set -euo pipefail

e="/etc"

if qvm-pool list 2>/dev/null | awk 'NR > 1 {print $2}' | grep -qx lvm_thin; then
  echo "refusing to run: an lvm_thin storage pool is in use and this removes lvm2" >&2
  exit 1
fi

# 1. remove remote and unused packages
rmv_pkgs="rmt openssh amd-gpu-firmware amd-ucode-firmware libdav1d lvm2"
installed_pkgs=$(rpm -q --qf '%{NAME}\n' $rmv_pkgs | grep -v ' is not installed$' || true)
[ -z "$installed_pkgs" ] || sudo dnf remove --noautoremove $installed_pkgs

# 2. remove remote connection configurations
rmv_cfgs="$e/ssh $e/crypto-policies/back-ends/ $e/libssh $e/lvm $e/host.conf $e/krb* $e/openldap $e/openal $e/netconfig $e/networks"
sudo rm -rf $rmv_cfgs

sudo sed -i "s|sss||g" /etc/nsswitch.conf
sudo sed -i "s|sss||g" /etc/authselect/nsswitch.conf
sudo sed -i "s|sssd||g" /etc/authselect/authselect.conf
sudo sed -i "s|with-silent-lastlog||g" /etc/authselect/authselect.conf
[ ! -f /etc/usb_modeswitch.conf ] || sudo sed -i "s|EnableLogging=0|EnableLogging=1|g" /etc/usb_modeswitch.conf # *?

printf "127.0.0.1\tlocalhost\n::1\tlocalhost6\n" | sudo tee /etc/hosts > /dev/null
