#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

VM_RC_LOCAL="/rw/config/rc.local"

die() {
  echo "$*" >&2
  exit 1
}

usage() {
  die "usage: $(basename "$0") <vm> <debian|fedora|path/to/rc.local> [--run]"
}

check_args() {
  [ "$#" -ge 2 ] && [ "$#" -le 3 ] || usage
  [ "$#" -lt 3 ] || [ "$3" = "--run" ] || usage
}

rc_local_source_for() {
  case "$1" in
    debian|fedora) echo "$SCRIPT_DIR/rc.local-$1" ;;
    *) echo "$1" ;;
  esac
}

check_rc_local_is_deployable() {
  local src
  src="$(rc_local_source_for "$1")"
  [ -f "$src" ] || die "no such rc.local: $src"
  bash -n "$src" || die "syntax error in $src, not deploying"
}

back_up_existing_rc_local() {
  qvm-run -q -p -u root "$1" \
    "[ ! -f $VM_RC_LOCAL ] || cp -a $VM_RC_LOCAL $VM_RC_LOCAL.bak-\$(date +%F-%H%M%S)" < /dev/null
}

push_rc_local() {
  qvm-run -q -p -u root "$1" "cat > $VM_RC_LOCAL && chmod 755 $VM_RC_LOCAL" < "$(rc_local_source_for "$2")"
}

report_deployed() {
  echo "deployed $(rc_local_source_for "$2") to $1:$VM_RC_LOCAL (runs on next start)"
}

run_now_if_asked() {
  [ "${3:-}" = "--run" ] || return 0
  echo "running $VM_RC_LOCAL in $1..."
  qvm-run -p -u root "$1" "$VM_RC_LOCAL" < /dev/null
}

main() {
  check_args "$@"
  check_rc_local_is_deployable "$2"
  back_up_existing_rc_local "$1"
  push_rc_local "$1" "$2"
  report_deployed "$1" "$2"
  run_now_if_asked "$@"
}

main "$@"
