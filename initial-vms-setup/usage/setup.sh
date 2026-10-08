#!/bin/bash

user=$1
admin=$2

# === start 1
# a) ask_for_user_if_missing
if [ -z "$user" ]; then
  read -p "enter the main user's username: " user
fi

# b) ask_for_admin_if_missing
if [ -z "$admin" ]; then
  read -p "add admin? " add_admin

  if [[ "$add_admin" == "y" || "$add_admin" == "Y" ]]; then
    read -p "enter admin username: " admin
  fi
fi
# === end 1


# === start 2
# a) run_usage_steps
cd "$(dirname "$0")" || exit 1
./scripts/1_update_etc_security.sh "$user" "$admin" || exit 1
./scripts/2_add_users.sh "$user" "$admin" || exit 1
./scripts/3_configure_selinux.sh "$user" "$admin" || exit 1
./scripts/4_secure_etc_default.sh || exit 1
# === end 2

echo -e "done.\n"
echo "optional scripts available."

