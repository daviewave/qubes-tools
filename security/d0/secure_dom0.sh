#!/bin/bash
set -euo pipefail

e="/etc"

# === start 1
# a) refuse_when_lvm_thin_pool_in_use
if qvm-pool list 2>/dev/null | awk 'NR > 1 {print $2}' | grep -qx lvm_thin; then
  echo "refusing to run: an lvm_thin storage pool is in use and this removes lvm2" >&2
  exit 1
fi

# === end 1
# === start 2
# a) remove_remote_and_unused_packages
rmv_pkgs="rmt openssh amd-gpu-firmware amd-ucode-firmware libdav1d lvm2"
installed_pkgs=$(rpm -q --qf '%{NAME}\n' $rmv_pkgs | grep -v ' is not installed$' || true)
[ -z "$installed_pkgs" ] || sudo dnf remove --noautoremove $installed_pkgs

# === end 2
# === start 3
# a) remove_remote_connection_configs
rmv_cfgs="$e/ssh $e/crypto-policies/back-ends/ $e/libssh $e/lvm $e/host.conf $e/krb* $e/openldap $e/openal $e/netconfig $e/networks"
sudo rm -rf $rmv_cfgs

# === end 3
# === start 4
# a) drop_sssd_from_nss_and_authselect
sudo sed -i "s|sss||g" /etc/nsswitch.conf
sudo sed -i "s|sss||g" /etc/authselect/nsswitch.conf
sudo sed -i "s|sssd||g" /etc/authselect/authselect.conf
sudo sed -i "s|with-silent-lastlog||g" /etc/authselect/authselect.conf
# b) log_usb_modeswitch
[ ! -f /etc/usb_modeswitch.conf ] || sudo sed -i "s|EnableLogging=0|EnableLogging=1|g" /etc/usb_modeswitch.conf # *?

# === end 4
# === start 5
# a) write_minimal_hosts
printf "127.0.0.1\tlocalhost\n::1\tlocalhost6\n" | sudo tee /etc/hosts > /dev/null
# === end 5
