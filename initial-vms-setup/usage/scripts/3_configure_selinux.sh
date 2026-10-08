#!/bin/bash

user=$1
admin=$2

# === start 1
# a) confine_root_home
semanage login -m -s root root
semanage fcontext -a -t admin_home_t "/root(/.*)?"
restorecon -R /root

# b) map_admin_to_sysadm_u
if [ -n "$admin" ]; then
  semanage login -a -s sysadm_u "$admin"
  semanage fcontext -a -t sysadm_home_t "/home/$admin(/.*)?"
  restorecon -R "/home/$admin"
  grep -qx "$admin:exclusive" /etc/security/sepermit.conf || echo "$admin:exclusive" >> /etc/security/sepermit.conf
fi

# c) map_user_to_user_u
semanage login -a -s user_u "$user"
semanage fcontext -a -t user_home_t "/home/$user(/.*)?"
restorecon -R "/home/$user"
# === end 1

echo "done."

