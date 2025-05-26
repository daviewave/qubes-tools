#!/bin/bash

if [[ ! -n "$qbp" || ! -n "$st" ]]; then
  echo "ERROR: pls source envs.sh file before running script, use cmd:"
  echo ". ./envs.sh || source ./envs.sh"
  exit 1
fi

exit 0


