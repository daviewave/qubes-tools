#!/bin/bash

services=("docker" "wpa_supplicant" "systemd-logind" "getty@tty1" "serial-getty@hvc0")
for s in "${services[@]}";
do
  systemctl restart $s.service
done

echo "restarting gui (start new terminal)..."
sleep 3
systemctl restart qubes-gui-agent.service

