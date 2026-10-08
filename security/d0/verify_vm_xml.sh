#!/usr/bin/env bash
set -euo pipefail

BASELINE_DIR="${XML_BASELINE_DIR:-$HOME/.local/share/qubes-tools/vm-xml-baseline}"
LIBVIRT_URI="xen:///"

die() {
  echo "$*" >&2
  exit 1
}

usage() {
  die "usage: $(basename "$0") <baseline|check> [vm...]"
}

check_args() {
  [ "$#" -ge 1 ] || usage
  case "$1" in
    baseline|check) ;;
    *) usage ;;
  esac
}

domains() {
  if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
  else
    sudo virsh -c "$LIBVIRT_URI" list --all --name | grep -v '^$'
  fi
}

normalized_xml() {
  sudo virsh -c "$LIBVIRT_URI" dumpxml --inactive "$1" < /dev/null \
    | sed -E "s/<domain type='xen' id='[0-9-]+'/<domain type='xen'/"
}

record_baseline() {
  mkdir -p "$BASELINE_DIR"
  chmod 700 "$BASELINE_DIR"
  local vm
  while read -r vm; do
    normalized_xml "$vm" > "$BASELINE_DIR/$vm.xml"
    echo "recorded $vm"
  done < <(domains "$@")
}

has_baseline() {
  [ -f "$BASELINE_DIR/$1.xml" ]
}

compare_one() {
  if ! has_baseline "$1"; then
    echo "NEW      $1 (no baseline)"
    return 1
  fi
  if normalized_xml "$1" | diff -u --label "baseline/$1" --label "current/$1" "$BASELINE_DIR/$1.xml" -; then
    echo "OK       $1"
  else
    echo "CHANGED  $1"
    return 1
  fi
}

report_vanished_domains() {
  local f vm status=0
  for f in "$BASELINE_DIR"/*.xml; do
    [ -e "$f" ] || continue
    vm="$(basename "$f" .xml)"
    sudo virsh -c "$LIBVIRT_URI" dominfo "$vm" &> /dev/null < /dev/null && continue
    echo "MISSING  $vm (in baseline, no longer defined)"
    status=1
  done
  return "$status"
}

check_against_baseline() {
  [ -d "$BASELINE_DIR" ] || die "no baseline at $BASELINE_DIR, run '$(basename "$0") baseline' first"
  local vm status=0
  while read -r vm; do
    compare_one "$vm" || status=1
  done < <(domains "$@")
  [ "$#" -gt 0 ] || report_vanished_domains || status=1
  return "$status"
}

run_mode() {
  local mode=$1
  shift
  case "$mode" in
    baseline) record_baseline "$@" ;;
    check) check_against_baseline "$@" ;;
  esac
}

main() {
  check_args "$@"
  run_mode "$@"
}

main "$@"
