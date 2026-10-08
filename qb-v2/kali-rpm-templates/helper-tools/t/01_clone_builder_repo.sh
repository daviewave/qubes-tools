#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=envs.sh
. "$SCRIPT_DIR/envs.sh"

BUILDER_REPO_URL="https://github.com/QubesOS/qubes-builderv2.git"
CLONE_STAGING="/home/user/qubes-builderv2"

builder_repo_present() {
  [ -d "$qbp/.git" ]
}

clone_builder_repo_unless_present() {
  if builder_repo_present; then
    echo "$qbp already cloned, skipping"
    return
  fi
  git clone "$BUILDER_REPO_URL" "$CLONE_STAGING"
  sudo mv "$CLONE_STAGING" "$qbp"
}

main() {
  echo "(1/6) cloning builderv2 git repo..."
  clone_builder_repo_unless_present
  echo "(1/6) done."
}

main "$@"
