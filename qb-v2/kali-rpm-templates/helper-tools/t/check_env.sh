#!/bin/bash

# === start 1
# a) require_envs_sourced
if [[ ! -n "$qbp" || ! -n "$st" ]]; then
  echo "ERROR: pls source envs.sh file before running script, use cmd:"
  echo ". ./envs.sh || source ./envs.sh"
  exit 1
fi
# === end 1

exit 0


