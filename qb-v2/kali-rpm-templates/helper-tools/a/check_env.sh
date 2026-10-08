#!/bin/bash

if [[ ! -n "$qbp" || ! -n "$st" ]]; then
  echo "ERROR: pls source proxy_envs.sh file before running script, use cmd:"
  echo ". ./proxy_envs.sh || source ./proxy_envs.sh"
  exit 1
fi

exit 0


