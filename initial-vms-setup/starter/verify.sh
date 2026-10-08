#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYSCTL_CONF="$SCRIPT_DIR/conf/90-qubes-hardening.conf"
BLACKLIST_CONF="$SCRIPT_DIR/conf/blacklist.conf"
SEBOOLS_OFF_CONF="$SCRIPT_DIR/conf/sebools-off.conf"

FAILURES=0

pass() {
  echo "PASS  $*"
}

fail() {
  echo "FAIL  $*"
  FAILURES=$((FAILURES + 1))
}

skip() {
  echo "SKIP  $*"
}

config_lines() {
  grep -Ev '^[[:space:]]*(#|$)' "$1"
}

sysctl_path() {
  echo "/proc/sys/${1//.//}"
}

check_one_sysctl() {
  local key=$1 want=$2 optional=$3 have
  if [ ! -e "$(sysctl_path "$key")" ]; then
    if [ "$optional" = yes ]; then skip "sysctl $key (not in this kernel)"; else fail "sysctl $key missing"; fi
    return
  fi
  have="$(cat "$(sysctl_path "$key")")"
  if [ "$have" = "$want" ]; then pass "sysctl $key = $want"; else fail "sysctl $key = $have (want $want)"; fi
}

check_sysctls() {
  local key want optional
  while IFS='=' read -r key want; do
    key="${key//[[:space:]]/}"
    want="${want//[[:space:]]/}"
    optional=no
    if [ "${key:0:1}" = "-" ]; then
      optional=yes
      key="${key:1}"
    fi
    check_one_sysctl "$key" "$want" "$optional"
  done < <(config_lines "$SYSCTL_CONF")
}

check_modules_locked() {
  if [ "$(cat /proc/sys/kernel/modules_disabled)" = 1 ]; then
    pass "module loading disabled"
  else
    fail "kernel.modules_disabled is not 1 (setup only sets it at runtime; re-run after boot)"
  fi
}

module_is_loaded() {
  grep -q "^${1//-/_} " /proc/modules
}

check_blacklisted_modules_not_loaded() {
  local mod
  while read -r mod; do
    if module_is_loaded "$mod"; then fail "module $mod is loaded"; else pass "module $mod not loaded"; fi
  done < <(config_lines "$BLACKLIST_CONF" | awk '$1 == "blacklist" {print $2}')
}

check_bools_off() {
  if ! command -v selinuxenabled > /dev/null || ! selinuxenabled; then
    skip "selinux booleans (selinux not enabled)"
    return
  fi
  local b state
  while read -r b; do
    if ! state="$(getsebool "$b" 2> /dev/null)"; then
      skip "boolean $b (not in loaded policy)"
    elif [[ "$state" == *"--> off" ]]; then
      pass "boolean $b off"
    else
      fail "boolean $b is on"
    fi
  done < <(config_lines "$SEBOOLS_OFF_CONF")
}

summarize() {
  echo
  if [ "$FAILURES" -eq 0 ]; then
    echo "all checks passed"
  else
    echo "$FAILURES check(s) failed"
    return 1
  fi
}

main() {
  check_sysctls
  check_modules_locked
  check_blacklisted_modules_not_loaded
  check_bools_off
  summarize
}

main "$@"
