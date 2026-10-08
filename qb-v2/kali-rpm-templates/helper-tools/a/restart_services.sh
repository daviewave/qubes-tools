#!/bin/bash

# === start 1
# a) restart_build_services
services=("docker" "wpa_supplicant" "systemd-logind" "getty@tty1" "serial-getty@hvc0")
for s in "${services[@]}";
do
  sudo systemctl restart "$s.service"
done
# === end 1

# === start 2
# a) restart_gui_agent
echo "restarting gui (start new terminal)..."
sleep 3
sudo systemctl restart qubes-gui-agent.service
# === end 2

