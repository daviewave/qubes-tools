#!/bin/bash

# shellcheck source=envs.sh
. "$(dirname "${BASH_SOURCE[0]}")/envs.sh"

cat "${st}/config/split-sign-macros.conf" > /home/user/.rpmmacros
