#!/bin/bash

chmod 700 /usr/bin/useradd
chmod 700 /usr/bin/adduser
chmod 750 /usr/bin/su*

setsebool -P unconfined_login off
passwd -l root

echo "done."
echo "dont forget to update /etc/passwd if intending to remove the user /sbin/nologin"
