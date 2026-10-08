#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TYPE_SPECIFIC_DIRS="instructions config helper-tools"

die() {
  echo "$*" >&2
  exit 1
}

setup_type_or_prompt() {
  local setup_type=${1:-}
  [ -n "$setup_type" ] || read -rp "are you preparing an appvm (a) or templatevm (t) ? (a/t): " setup_type
  echo "$setup_type"
}

check_setup_type() {
  [ "$1" = a ] || [ "$1" = t ] || die "setup type must be 'a' (appvm) or 't' (templatevm), got '$1'"
}

wrkdir_for() {
  echo "$SCRIPT_DIR/transfer-pkgs/$1-setup-tools"
}

recreate_wrkdir() {
  rm -rf "$(wrkdir_for "$1")"
  mkdir -p "$(wrkdir_for "$1")"
}

copy_type_specific_dirs() {
  local d
  for d in $TYPE_SPECIFIC_DIRS; do
    [ -d "$SCRIPT_DIR/$d/$1" ] || continue
    mkdir -p "$(wrkdir_for "$1")/$d"
    cp -r "$SCRIPT_DIR/$d/$1"/. "$(wrkdir_for "$1")/$d"
  done
}

copy_builders() {
  mkdir -p "$(wrkdir_for "$1")/builders"
  cp "$SCRIPT_DIR"/builders/* "$(wrkdir_for "$1")/builders/"
}

report_location() {
  echo "setup tools available at: '$(wrkdir_for "$1")'"
}

copy_to_vm_if_given() {
  if [ -z "$2" ]; then
    echo "copy to setup vm with: 'qvm-copy-to-vm <setup vm> $(wrkdir_for "$1")'"
  else
    qvm-copy-to-vm "$2" "$(wrkdir_for "$1")"
  fi
}

package_and_send() {
  check_setup_type "$1"
  recreate_wrkdir "$1"
  copy_type_specific_dirs "$1"
  copy_builders "$1"
  report_location "$1"
  copy_to_vm_if_given "$1" "$2"
}

main() {
  package_and_send "$(setup_type_or_prompt "${1:-}")" "${2:-}"
  echo "done."
}

main "$@"
