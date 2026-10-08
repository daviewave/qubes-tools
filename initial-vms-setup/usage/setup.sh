#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

user_or_prompt() {
  local user=${1:-}
  [ -n "$user" ] || read -rp "enter the main user's username: " user
  echo "$user"
}

admin_or_prompt() {
  local admin=${1:-} add_admin
  if [ -z "$admin" ]; then
    read -rp "add admin? " add_admin
    [[ "$add_admin" != [yY] ]] || read -rp "enter admin username: " admin
  fi
  echo "$admin"
}

run_usage_steps() {
  "$SCRIPT_DIR/scripts/1_update_etc_security.sh" "$1" "$2"
  "$SCRIPT_DIR/scripts/2_add_users.sh" "$1" "$2"
  "$SCRIPT_DIR/scripts/3_configure_selinux.sh" "$1" "$2"
  "$SCRIPT_DIR/scripts/4_secure_etc_default.sh"
}

point_at_optional_scripts() {
  echo -e "done.\n"
  echo "optional scripts available: $SCRIPT_DIR/scripts/restrict_access.sh"
}

main() {
  run_usage_steps "$(user_or_prompt "${1:-}")" "$(admin_or_prompt "${2:-}")"
  point_at_optional_scripts
}

main "$@"
