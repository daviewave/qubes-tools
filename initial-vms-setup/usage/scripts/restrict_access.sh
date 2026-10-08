#!/bin/bash

# === start 1
# a) restrict_useradd_to_root
for f in /usr/sbin/useradd /usr/share/bash-completion/completions/useradd /etc/default/useradd /usr/bin/useradd /usr/bin/adduser;
do
  [ -e "$f" ] && chmod 700 "$f"
done

# b) restrict_su_to_wheel
chgrp wheel /usr/bin/su
chmod 4750 /usr/bin/su

# c) disable_unconfined_login
setsebool -P unconfined_login off
# d) lock_root_password
passwd -l root

# === end 1
echo "done."
echo "dont forget to update /etc/passwd if intention is to remove guest user login (/sbin/nologin)"
