#!/bin/bash

# shellcheck source=envs.sh
. "$(dirname "${BASH_SOURCE[0]}")/envs.sh"

# === start 1
# a) install_split_gpg_rpm_macros
cat "${st}/config/split-sign-macros.conf" > /home/user/.rpmmacros
# === end 1
