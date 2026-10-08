#!/bin/bash
set -euo pipefail

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
keep=" fingerprint-auth password-auth postlogin smartcard-auth su su-l sudo sudo-i system-auth other login passwd runuser runuser-l systemd-user qrexec "
sudo tar -czf "/root/pam.d-$(date +%F-%H%M%S).tar.gz" -C /etc pam.d
for f in /etc/pam.d/*;
do
  [[ "$keep" == *" ${f##*/} "* ]] || sudo rm -f -- "$f"
done

