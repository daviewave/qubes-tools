#!/bin/bash

user=$1
admin=$2

# === start 1
# a) create_user_with_password
id "$user" &>/dev/null || useradd "$user"
passwd "$user"



# b) create_admin_in_wheel
if [[ -n "$admin" ]]; then
  id "$admin" &>/dev/null || useradd "$admin"
  passwd "$admin"
  usermod -aG wheel "$admin"
fi
# === end 1

echo "done."


