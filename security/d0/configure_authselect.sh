#!/bin/bash

# 1, remove remote access authselect profiles
sudo rm -rf /usr/share/authselect/default/nis
sudo rm -rf /usr/share/authselect/default/sssd
sudo rm -rf /usr/share/authselect/default/winbind

# 2, select local (*eventually want to create custom instead of use local*) 
sudo authselect select local
for feat in with-faillock with-ecryptfs with-mkhomedir with-pamaccess with-systemd-homed without-nullok without-pam-u2f-nouserok;
do
  sudo authselect enable-feature $feat
done
sudo authselect apply-changes

# 3, clean up /etc/pam.d/ to prevent unwanted logins
for i in $(ls /etc/pam.d/ | grep -Ev "(fingerprint-auth|password-auth|postlogin|smartcard-auth|su|system-auth)");
do
  sudo rm $i
done

