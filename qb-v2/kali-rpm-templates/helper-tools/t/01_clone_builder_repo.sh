#!/bin/bash

# shellcheck source=envs.sh
. "$(dirname "${BASH_SOURCE[0]}")/envs.sh"

echo "(1/6) cloning builderv2 git repo..."

# === start 1
# a) clone_builder_repo_unless_present
if [ -d "${qbp}/.git" ]; then
  echo "${qbp} already cloned, skipping"
else
  git clone https://github.com/QubesOS/qubes-builderv2.git /home/user/qubes-builderv2
  sudo mv /home/user/qubes-builderv2 "${qbp}"
fi
# === end 1

echo "(1/6) done."
