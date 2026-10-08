#!/usr/bin/env bash
set -euo pipefail

envs_are_sourced() {
  [ -n "${qbp:-}" ] && [ -n "${st:-}" ]
}

require_envs_sourced() {
  envs_are_sourced && return 0
  echo "ERROR: pls source proxy_envs.sh file before running script, use cmd:"
  echo ". ./proxy_envs.sh || source ./proxy_envs.sh"
  exit 1
}

main() {
  require_envs_sourced
}

main "$@"
