#!/usr/bin/env bash
set -euo pipefail

NSSWITCH="/etc/nsswitch.conf"
DB_DATABASES="passwd group shadow gshadow"

die() {
  echo "$*" >&2
  exit 1
}

usage() {
  die "usage: $(basename "$0") [--switch]"
}

check_args() {
  [ "$#" -le 1 ] || usage
  [ "$#" -eq 0 ] || [ "$1" = "--switch" ] || usage
}

check_root() {
  [ "$(id -u)" -eq 0 ] || die "run as root"
}

is_debian_like() {
  command -v apt-get > /dev/null
}

db_dir() {
  if is_debian_like; then echo /var/lib/misc; else echo /var/db; fi
}

nss_db_package() {
  if is_debian_like; then echo libnss-db; else echo nss_db; fi
}

nss_db_is_installed() {
  [ -f "$(db_dir)/Makefile" ]
}

install_nss_db_if_missing() {
  nss_db_is_installed && return 0
  if is_debian_like; then
    apt-get install -y "$(nss_db_package)"
  else
    dnf install -y "$(nss_db_package)"
  fi
}

build_db_files() {
  make -C "$(db_dir)"
  chmod 600 "$(db_dir)"/shadow.db "$(db_dir)"/gshadow.db 2> /dev/null || true
}

db_resolves() {
  getent -s db "$1" "$2" > /dev/null
}

verify_db_files() {
  db_resolves passwd root || die "db lookup of passwd:root failed, leaving $NSSWITCH alone"
  db_resolves group root || die "db lookup of group:root failed, leaving $NSSWITCH alone"
  db_resolves shadow root || die "db lookup of shadow:root failed, leaving $NSSWITCH alone"
  echo "db files in $(db_dir) resolve root"
}

back_up_nsswitch() {
  cp -L "$NSSWITCH" "$NSSWITCH.bak-$(date +%F-%H%M%S)"
}

point_nsswitch_at_db() {
  local database
  for database in $DB_DATABASES; do
    if grep -q "^$database:" "$NSSWITCH"; then
      sed -i --follow-symlinks "s|^$database:.*|$database:\t\tdb|" "$NSSWITCH"
    else
      printf '%s:\t\tdb\n' "$database" >> "$NSSWITCH"
    fi
  done
  echo "$NSSWITCH now uses db for: $DB_DATABASES"
}

switch_if_asked() {
  [ "${1:-}" = "--switch" ] || {
    echo "re-run with --switch to point $NSSWITCH at the db files"
    return 0
  }
  back_up_nsswitch
  point_nsswitch_at_db
}

remind_to_rebuild() {
  echo "rebuild after any user/group change with: make -C $(db_dir)"
}

main() {
  check_args "$@"
  check_root
  install_nss_db_if_missing
  build_db_files
  verify_db_files
  switch_if_asked "$@"
  remind_to_rebuild
}

main "$@"
