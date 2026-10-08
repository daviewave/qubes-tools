#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SEBOOLS_OFF_CONF="$SCRIPT_DIR/../conf/sebools-off.conf"

wanted_bools() {
  grep -Ev '^[[:space:]]*(#|$)' "$SEBOOLS_OFF_CONF"
}

policy_defines() {
  getsebool "$1" &> /dev/null
}

off_settings_for_known_bools() {
  local b
  while read -r b; do
    if policy_defines "$b"; then
      echo "$b=off"
    else
      echo "skipping unknown boolean: $b" >&2
    fi
  done < <(wanted_bools)
}

turn_bools_off() {
  local settings
  mapfile -t settings < <(off_settings_for_known_bools)
  [ "${#settings[@]}" -eq 0 ] || setsebool -P "${settings[@]}"
}

main() {
  turn_bools_off
  echo "done."
}

main "$@"
