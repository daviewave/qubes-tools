#!/usr/bin/env bash
set -euo pipefail

VM_NFT_DIR="/rw/config/nft"
VM_HOOK_DIR="/rw/config/qubes-firewall.d"
HOOK_PRIORITY="90"

die() {
  echo "$*" >&2
  exit 1
}

usage() {
  die "usage: $(basename "$0") <vm> <ruleset.nft> [--apply]"
}

check_args() {
  [ "$#" -ge 2 ] && [ "$#" -le 3 ] || usage
  [ "$#" -lt 3 ] || [ "$3" = "--apply" ] || usage
  [ -f "$2" ] || die "no such ruleset: $2"
}

ruleset_name() {
  basename "$1" .nft
}

vm_ruleset_path() {
  echo "$VM_NFT_DIR/$(ruleset_name "$1").nft"
}

vm_hook_path() {
  echo "$VM_HOOK_DIR/$HOOK_PRIORITY-$(ruleset_name "$1")"
}

push_ruleset() {
  # shellcheck disable=SC2094 # the write target is inside the qube
  qvm-run -q -p -u root "$1" \
    "mkdir -p $VM_NFT_DIR && cat > $(vm_ruleset_path "$2")" < "$2"
}

reject_ruleset_nft_cannot_parse() {
  qvm-run -q -p -u root "$1" "nft -c -f $(vm_ruleset_path "$2")" < /dev/null && return 0
  qvm-run -q -p -u root "$1" "rm -f $(vm_ruleset_path "$2")" < /dev/null
  die "nft rejected $2 inside $1, nothing installed"
}

install_firewall_hook() {
  printf '#!/bin/sh\nexec nft -f %s\n' "$(vm_ruleset_path "$2")" \
    | qvm-run -q -p -u root "$1" \
      "mkdir -p $VM_HOOK_DIR && cat > $(vm_hook_path "$2") && chmod 755 $(vm_hook_path "$2")"
}

report_installed() {
  echo "installed $(ruleset_name "$2") in $1; qubes-firewall loads it via $(vm_hook_path "$2")"
}

apply_now_if_asked() {
  [ "${3:-}" = "--apply" ] || return 0
  qvm-run -p -u root "$1" "$(vm_hook_path "$2")" < /dev/null
  echo "applied $(ruleset_name "$2") in $1"
}

main() {
  check_args "$@"
  push_ruleset "$1" "$2"
  reject_ruleset_nft_cannot_parse "$1" "$2"
  install_firewall_hook "$1" "$2"
  report_installed "$1" "$2"
  apply_now_if_asked "$@"
}

main "$@"
