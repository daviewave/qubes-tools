#!/bin/bash
set -euo pipefail

# === start 1
# a) drop_remote_auth_profiles
sudo rm -rf /usr/share/authselect/default/nis
sudo rm -rf /usr/share/authselect/default/sssd
sudo rm -rf /usr/share/authselect/default/winbind

# === end 1
# === start 2
# a) select_local_profile_with_hardening_features (*eventually want to create custom instead of use local*)
sudo authselect select local
for feat in with-faillock with-ecryptfs with-mkhomedir with-pamaccess with-systemd-homed without-nullok without-pam-u2f-nouserok;
do
  sudo authselect enable-feature $feat
done
sudo authselect apply-changes

# === end 2
# === start 3
# a) KEEP_PAM_SERVICES: login services the dom0 needs
keep=" fingerprint-auth password-auth postlogin smartcard-auth su su-l sudo sudo-i system-auth other login passwd runuser runuser-l systemd-user lightdm lightdm-greeter xscreensaver polkit-1 "
# b) back_up_pam_d
sudo tar -czf "/root/pam.d-$(date +%F-%H%M%S).tar.gz" -C /etc pam.d
# c) remove_pam_services_not_kept
for f in /etc/pam.d/*;
do
  [[ "$keep" == *" ${f##*/} "* ]] || sudo rm -f -- "$f"
done
# === end 3

