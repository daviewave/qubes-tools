#!/bin/bash

user=$1
admin=$2

useradd $user
passwd $user



if [[ -n "$admin" ]]; then
  useradd $admin
  passwd $admin
  usermod -aG wheel $admin
fi

echo "done."


