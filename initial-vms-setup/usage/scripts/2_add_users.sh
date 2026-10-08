#!/usr/bin/env bash
set -euo pipefail

user_exists() {
  id "$1" &> /dev/null
}

create_user_with_password() {
  user_exists "$1" || useradd "$1"
  passwd "$1"
}

create_admin_in_wheel() {
  [ -n "$1" ] || return 0
  create_user_with_password "$1"
  usermod -aG wheel "$1"
}

main() {
  create_user_with_password "$1"
  create_admin_in_wheel "${2:-}"
  echo "done."
}

main "$@"
