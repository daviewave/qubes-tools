#!/bin/bash

user=$1
admin=$2

if [ -z $user ]; then
  read -p "enter the main user's username: " user
fi

if [ -z $admin ]; then
  read -p "add admin? " add_admin

  if [[ "$add_admin" == "y" || "$add_admin" == "Y" ]]; then
    read -p "enter admin username: " admin
  fi
fi


./scripts/1_update_etc_security.sh $user $admin
./scripts/2_add_users.sh $user $admin
./scripts/3_configure_selinux.sh $user $admin
./scripts/4_secure_etc_default.sh

echo -e "done.\n"
echo "optional scripts available."

