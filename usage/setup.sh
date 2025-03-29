#!/bin/bash

user=$1
admin=$2

#1. get username if not passed in
if [ -z $user ]; then
  read -p "enter the main user's username: " user
fi

#2. check admin variable, make sure dont want to add if not there, if do want to add get input
if [[ -z "$admin" ]]; then
  read -p "add admin user? " add_admin

  if [[ "$add_admin" == "y" || "$add_admin" == "Y" ]]; then
    read -p "enter admin username: " admin
  fi
fi

./scripts/1_update_etc_security.sh $user $admin
./scripts/2_add_users.sh $user $admin
./scripts/3_configure_selinux.sh $user $admin

echo "done."
echo ""
echo "optional scripts available."
