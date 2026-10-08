#!/usr/bin/env bash
set -euo pipefail

REMOTE_AUTH_PROFILES="nis sssd winbind"
HARDENING_FEATURES="with-faillock with-ecryptfs with-mkhomedir with-pamaccess with-systemd-homed without-nullok without-pam-u2f-nouserok"
KEEP_PAM_SERVICES=" fingerprint-auth password-auth postlogin smartcard-auth su su-l sudo sudo-i system-auth other login passwd runuser runuser-l systemd-user lightdm lightdm-greeter xscreensaver polkit-1 "

drop_remote_auth_profiles() {
  local profile
  for profile in $REMOTE_AUTH_PROFILES; do
    sudo rm -rf "/usr/share/authselect/default/$profile"
  done
}

# TODO: replace 'local' with a custom profile.
select_local_profile_with_hardening_features() {
  sudo authselect select local
  local feat
  for feat in $HARDENING_FEATURES; do
    sudo authselect enable-feature "$feat"
  done
  sudo authselect apply-changes
}

back_up_pam_d() {
  sudo tar -czf "/root/pam.d-$(date +%F-%H%M%S).tar.gz" -C /etc pam.d
}

is_kept_pam_service() {
  [[ "$KEEP_PAM_SERVICES" == *" $1 "* ]]
}

remove_pam_services_dom0_does_not_need() {
  local f
  for f in /etc/pam.d/*; do
    is_kept_pam_service "${f##*/}" || sudo rm -f -- "$f"
  done
}

main() {
  drop_remote_auth_profiles
  select_local_profile_with_hardening_features
  back_up_pam_d
  remove_pam_services_dom0_does_not_need
}

main "$@"
