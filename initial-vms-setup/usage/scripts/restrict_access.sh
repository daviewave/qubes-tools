#!/bin/bash

for f in /usr/sbin/useradd /usr/share/bash-completion/completions/useradd /etc/default/useradd /usr/bin/useradd /usr/bin/adduser;
do
  [ -e "$f" ] && chmod 700 "$f"
done

chgrp wheel /usr/bin/su
chmod 4750 /usr/bin/su

setsebool -P unconfined_login off
passwd -l root

echo "done."
echo "dont forget to update /etc/passwd if intention is to remove guest user login (/sbin/nologin)"
