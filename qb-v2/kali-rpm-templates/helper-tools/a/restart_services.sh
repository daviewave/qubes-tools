#!/usr/bin/env bash
set -euo pipefail

BUILD_SERVICES="docker wpa_supplicant systemd-logind getty@tty1 serial-getty@hvc0"

restart_build_services() {
  local s
  for s in $BUILD_SERVICES; do
    sudo systemctl restart "$s.service"
  done
}

restart_gui_agent() {
  echo "restarting gui (start new terminal)..."
  sleep 3
  sudo systemctl restart qubes-gui-agent.service
}

main() {
  restart_build_services
  restart_gui_agent
}

main "$@"
