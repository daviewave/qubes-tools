#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="/var/lib/qubes"
QUBE_DATA_DIRS="appvms vm-kernels vm-templates backup"
BACKUP_DIR="$HOME/backups/all"

BACKUP=0
DRY_RUN=0

die() {
  echo -e "$*" >&2
  exit 1
}

parse_args() {
  local arg
  for arg in "$@"; do
    case "$arg" in
      1|--backup) BACKUP=1 ;;
      -n|--dry-run) DRY_RUN=1 ;;
      *) die "usage: $(basename "$0") [--backup] [--dry-run]" ;;
    esac
  done
}

running_qubes() {
  qvm-ls --running --raw-list | grep -vx dom0 || true
}

refuse_while_qubes_run() {
  local running
  running="$(running_qubes)"
  [ -z "$running" ] || die "shut down every qube before converting, still running:\n$running"
}

back_up_qubes_xml_if_asked() {
  [ "$BACKUP" -eq 1 ] || return 0
  local backup_fp
  backup_fp="$BACKUP_DIR/qubes-$(date +%F-%H%M%S).tar.gz"
  mkdir -p "$BACKUP_DIR"
  sudo tar -cpzf "$backup_fp" -C "$DATA_DIR" qubes.xml backup
  sudo chown "$USER:" "$backup_fp"
  echo -e "backed up qubes.xml and $DATA_DIR/backup to: $backup_fp \n"
}

is_btrfs_subvol() {
  sudo btrfs subvolume show "$1" &> /dev/null
}

writes_are_disabled() {
  [ "$DRY_RUN" -eq 1 ]
}

convert_to_btrfs_subvol() {
  local qube_datad=$1
  local tmp_dir="${qube_datad}.tmp"

  if is_btrfs_subvol "$qube_datad"; then
    echo "  already a subvolume: $qube_datad"
    return
  fi
  if writes_are_disabled; then
    echo "  would convert: $qube_datad"
    return
  fi

  echo "  converting: $qube_datad"
  sudo mv "$qube_datad" "$tmp_dir"
  sudo btrfs subvolume create "$qube_datad" > /dev/null
  sudo cp -a --reflink=always "$tmp_dir"/. "$qube_datad"/
  sudo rm -rf "$tmp_dir"
}

convert_every_qube_dir() {
  local datad qube_datad
  for datad in $QUBE_DATA_DIRS; do
    echo "converting $DATA_DIR/$datad/* to btrfs subvolumes"
    for qube_datad in "$DATA_DIR/$datad"/*/; do
      [ -d "$qube_datad" ] || continue
      convert_to_btrfs_subvol "${qube_datad%/}"
    done
  done
}

main() {
  parse_args "$@"
  refuse_while_qubes_run
  back_up_qubes_xml_if_asked
  convert_every_qube_dir
  echo "done."
}

main "$@"
