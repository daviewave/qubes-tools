#!/usr/bin/env bash
set -euo pipefail

UNUSED_PACKAGES="rmt openssh amd-gpu-firmware amd-ucode-firmware libdav1d lvm2"
REMOTE_CONNECTION_CONFIGS="/etc/ssh /etc/crypto-policies/back-ends/ /etc/libssh /etc/lvm /etc/host.conf /etc/krb* /etc/openldap /etc/openal /etc/netconfig /etc/networks"

die() {
  echo "$*" >&2
  exit 1
}

lvm_thin_pool_in_use() {
  qvm-pool list 2> /dev/null | awk 'NR > 1 {print $2}' | grep -qx lvm_thin
}

refuse_when_lvm_thin_pool_in_use() {
  if lvm_thin_pool_in_use; then
    die "refusing to run: an lvm_thin storage pool is in use and this removes lvm2"
  fi
}

installed_packages_among() {
  # shellcheck disable=SC2086 # word-split the package list
  rpm -q --qf '%{NAME}\n' $1 | grep -v ' is not installed$' || true
}

remove_remote_and_unused_packages() {
  local installed
  installed="$(installed_packages_among "$UNUSED_PACKAGES")"
  [ -z "$installed" ] || sudo dnf remove --noautoremove $installed
}

remove_remote_connection_configs() {
  # shellcheck disable=SC2086 # word-split and glob the config list
  sudo rm -rf $REMOTE_CONNECTION_CONFIGS
}

drop_sssd_from_nss_and_authselect() {
  sudo sed -i "s|sss||g" /etc/nsswitch.conf
  sudo sed -i "s|sss||g" /etc/authselect/nsswitch.conf
  sudo sed -i "s|sssd||g" /etc/authselect/authselect.conf
  sudo sed -i "s|with-silent-lastlog||g" /etc/authselect/authselect.conf
}

log_usb_modeswitch() {
  [ ! -f /etc/usb_modeswitch.conf ] || sudo sed -i "s|EnableLogging=0|EnableLogging=1|g" /etc/usb_modeswitch.conf
}

write_minimal_hosts() {
  printf "127.0.0.1\tlocalhost\n::1\tlocalhost6\n" | sudo tee /etc/hosts > /dev/null
}

main() {
  refuse_when_lvm_thin_pool_in_use
  remove_remote_and_unused_packages
  remove_remote_connection_configs
  drop_sssd_from_nss_and_authselect
  log_usb_modeswitch
  write_minimal_hosts
}

main "$@"
