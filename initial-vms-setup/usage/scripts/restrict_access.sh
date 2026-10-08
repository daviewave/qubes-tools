#!/usr/bin/env bash
set -euo pipefail

USERADD_PATHS="/usr/sbin/useradd /usr/share/bash-completion/completions/useradd /etc/default/useradd /usr/bin/useradd /usr/bin/adduser"

restrict_useradd_to_root() {
  local f
  for f in $USERADD_PATHS; do
    [ ! -e "$f" ] || chmod 700 "$f"
  done
}

restrict_su_to_wheel() {
  chgrp wheel /usr/bin/su
  chmod 4750 /usr/bin/su
}

disable_unconfined_login() {
  setsebool -P unconfined_login off
}

lock_root_password() {
  passwd -l root
}

remind_about_guest_login() {
  echo "done."
  echo "dont forget to update /etc/passwd if intention is to remove guest user login (/sbin/nologin)"
}

main() {
  restrict_useradd_to_root
  restrict_su_to_wheel
  disable_unconfined_login
  lock_root_password
  remind_about_guest_login
}

main "$@"
