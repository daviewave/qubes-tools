#!/bin/bash
set -euo pipefail

bad_bools=(
  "abrt_handle_event"
  "abrt_upload_watch_anon_write"
  "cron_userdomain_transition"
  "daemons_dontaudit_scheduling"
  "entropyd_use_audio"
  "gluster_export_all_rw"
  "gssd_read_tmp"
  "httpd_builtin_scripting"
  "httpd_enable_cgi"
  "init_audit_control"
  "kerberos_enabled"
  "postgresql_selinux_unconfined_dbadm"
  "postgresql_selinux_users_ddl"
  "logging_syslogd_use_tty"
  "mount_anyfile"
  "mozilla_plugin_can_network_connect"
  "named_write_master_zones"
  "nfs_export_all_ro"
  "nfs_export_all_rw"
  "openfortivpn_can_network_connect"
  "openvpn_can_network_connect"
  "openvpn_enable_homedirs"
  "postfix_local_write_mail_spool"
  "privoxy_connect_any"
  "selinuxuser_direct_dri_enabled"
  "selinuxuser_execmod"
  "selinuxuser_execstack"
  "selinuxuser_ping"
  "selinuxuser_rw_noexattrfile"
  "spamd_enable_home_dirs"
  "squid_connect_any"
  "telepathy_tcp_connect_generic_network_ports"
  "unconfined_chrome_sandbox_transition"
  "unconfined_mozilla_plugin_transition"
  "use_virtualbox"
  "virt_sandbox_use_all_caps"
  "virt_sandbox_use_audit"
  "virt_use_usb"
  "xdm_manage_bootloader"
  "xguest_connect_network"
  "xguest_mount_media"
  "xguest_use_bluetooth"
)


exec_bools=(
  "auditadm_exec_content"
  "dbadm_exec_content"
  "guest_exec_content"
  "logadm_exec_content"
  "secadm_exec_content"
  "staff_exec_content"
  "xguest_exec_content"
)

mapfile -t known < <(getsebool -a | cut -d' ' -f1)
settings=()
for b in "${bad_bools[@]}" "${exec_bools[@]}"; do
  if printf '%s\n' "${known[@]}" | grep -qx "$b"; then
    settings+=("$b=off")
  else
    echo "skipping unknown boolean: $b"
  fi
done

setsebool -P "${settings[@]}"

echo "done."

