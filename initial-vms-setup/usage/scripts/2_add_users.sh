#!/bin/bash

user=$1
admin=$2

id "$user" &>/dev/null || useradd "$user"
passwd "$user"



if [[ -n "$admin" ]]; then
  id "$admin" &>/dev/null || useradd "$admin"
  passwd "$admin"
  usermod -aG wheel "$admin"
fi

echo "done."


