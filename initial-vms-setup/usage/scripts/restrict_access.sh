#!/bin/bash

chmod 700 /usr/sbin/useradd
chmod 700 /usr/share/bash-completion/completions/useradd
chmod 700 /etc/default/useradd
chmod 700 /usr/bin/useradd
chmod 700 /usr/bin/adduser

chmod 750 /usr/bin/su*

setsebool -P unconfined_login off
passwd -l root

echo "done."
echo "dont forget to update /etc/passwd if intention is to remove guest user login (/sbin/nologin)"
