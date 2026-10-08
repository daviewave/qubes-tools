#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  echo "Preparing debian-12 based TemplateVM to build kali linux based rpm TemplateVM's..."
  "$SCRIPT_DIR/01_clone_builder_repo.sh"
  "$SCRIPT_DIR/02_add_custom_tools.sh"
  "$SCRIPT_DIR/03_import_gpg_keys.sh"
  "$SCRIPT_DIR/04_add_kali_list.sh"
  "$SCRIPT_DIR/05_big_update.sh"
  "$SCRIPT_DIR/06_prep_env.sh"
  echo "DONE. build with: $SCRIPT_DIR/build_template.sh"
}

main "$@"
