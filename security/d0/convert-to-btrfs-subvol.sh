#!/bin/bash
set -euo pipefail

data="/var/lib/qubes"
qube_data_dirs=("appvms" "vm-kernels" "vm-templates" "backup")

backup=0
dry_run=0
for arg in "$@"; do
  case "$arg" in
    1|--backup) backup=1 ;;
    -n|--dry-run) dry_run=1 ;;
    *) echo "usage: $(basename "$0") [--backup] [--dry-run]" >&2; exit 1 ;;
  esac
done

running=$(qvm-ls --running --raw-list | grep -vx dom0 || true)
if [ -n "$running" ]; then
  echo -e "shut down every qube before converting, still running:\n$running" >&2
  exit 1
fi

if [ "$backup" -eq 1 ]; then
  backup_fp="$HOME/backups/all/qubes-$(date +%F-%H%M%S).tar.gz"
  mkdir -p "$(dirname "$backup_fp")"
  sudo tar -cpzf "$backup_fp" -C "$data" qubes.xml backup
  sudo chown "$USER:" "$backup_fp"
  echo -e "backed up qubes.xml and $data/backup to: $backup_fp \n"
fi

is_btrfs_subvol() {
  sudo btrfs subvolume show "$1" &> /dev/null
}

convert_to_btrfs_subvol() {
  local qube_datad=$1
  local tmp_dir="${qube_datad}.tmp"

  if is_btrfs_subvol "$qube_datad"; then
    echo "  already a subvolume: $qube_datad"
    return
  fi
  if [ "$dry_run" -eq 1 ]; then
    echo "  would convert: $qube_datad"
    return
  fi

  echo "  converting: $qube_datad"
  sudo mv "$qube_datad" "$tmp_dir"
  sudo btrfs subvolume create "$qube_datad" > /dev/null
  sudo cp -a --reflink=always "$tmp_dir"/. "$qube_datad"/
  sudo rm -rf "$tmp_dir"
}

for datad in "${qube_data_dirs[@]}"; do
  echo "converting $data/$datad/* to btrfs subvolumes"
  for qube_datad in "$data/$datad"/*/; do
    [ -d "$qube_datad" ] || continue
    convert_to_btrfs_subvol "${qube_datad%/}"
  done
done

echo "done."
