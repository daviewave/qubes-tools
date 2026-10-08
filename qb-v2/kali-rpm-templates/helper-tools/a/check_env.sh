#!/bin/bash

# === start 1
# a) require_envs_sourced
if [[ ! -n "$qbp" || ! -n "$st" ]]; then
  echo "ERROR: pls source proxy_envs.sh file before running script, use cmd:"
  echo ". ./proxy_envs.sh || source ./proxy_envs.sh"
  exit 1
fi
# === end 1

exit 0


