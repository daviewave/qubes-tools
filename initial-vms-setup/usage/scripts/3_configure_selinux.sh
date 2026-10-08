#!/usr/bin/env bash
set -euo pipefail

SEPERMIT_CONF=/etc/security/sepermit.conf

confine_root_home() {
  semanage login -m -s root root
  semanage fcontext -a -t admin_home_t "/root(/.*)?"
  restorecon -R /root
}

map_login_to_selinux_user() {
  local login=$1 se_user=$2 home_type=$3
  semanage login -a -s "$se_user" "$login"
  semanage fcontext -a -t "$home_type" "/home/$login(/.*)?"
  restorecon -R "/home/$login"
}

map_admin_to_sysadm_u() {
  [ -n "$1" ] || return 0
  map_login_to_selinux_user "$1" sysadm_u sysadm_home_t
  grep -qx "$1:exclusive" "$SEPERMIT_CONF" || echo "$1:exclusive" >> "$SEPERMIT_CONF"
}

map_user_to_user_u() {
  map_login_to_selinux_user "$1" user_u user_home_t
}

main() {
  confine_root_home
  map_admin_to_sysadm_u "${2:-}"
  map_user_to_user_u "$1"
  echo "done."
}

main "$@"
