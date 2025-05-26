#!/bin/bash

backup=$1
data="/var/lib/qubes"
mtv_qube_data=("appvms" "vm-kernels" "vm-templates" "backup")

if [ "$backup" -eq 1  ]; then
  date=$(date | awk '{print $2 "-" $3}')
  backup_fp = /home/$USER/backups/all/$date.tar.gz
  tar -cvpzf $backup_fp /var/lib/qubes/backup
  echo -e "backed up current existing vm data to: $backup_fp \n"
fi

convert_to_btrfs_subvol() {
  trgt_dir=$1

  for qube_datad in $trgt_dir/*; do
    tmp_dir="${qube_datad}.tmp"
    sudo mv $qube_datad $tmp_dir
    sudo btrfs subvolume create $qube_datad
    sudo mv $tmp_dir/* $qube_datad
    sudo rm -rf $tmp_dir
  done
}



for mtv_datad in $data/*; do
  for datad in "${mtv_qube_data[@]}"; do
    echo "converting $datad to btrfs volume"
    convert_to_btrfs_subvol $mtv_datad
    echo "done."
  done
done
