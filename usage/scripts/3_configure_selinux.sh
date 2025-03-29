#!/bin/bash

user=$1
admin=$2

semanage login -m -s root root
semanage fcontext -a -t admin_home_t "/root(/.*)?"
restorecon -R /root

semanage login -a -s sysadm_u $admin
semanage fcontext -a -t sysadm_home_t "/home/$admin(/.*)?"
restorecon -R /home/$admin

semanage login -a -s user_u $user
semanage fcontext -a -t user_home_t "/home/$user(/.*)?"
restorecon -R /home/$user

echo "$admin:exclusive" >> /etc/security/sepermit.conf

echo "done."
