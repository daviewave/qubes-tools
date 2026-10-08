#!/usr/bin/env bash
set -euo pipefail

DISTRIBUTION_OSES="debian ubuntu"
MOUNT_LOOP_LINE=141

remove_double_slash_before_tmpdir() {
  local matches match
  mapfile -t matches < <(grep -Rl "\${INSTALL_DIR}/\${TMPDIR}" ./ || true)
  for match in "${matches[@]}"; do
    echo "removing extra '/' from path in script: $match"
    sed -i 's|\${INSTALL_DIR}/\${TMPDIR}|\${INSTALL_DIR}\${TMPDIR}|g' "$match"
  done
}

has_mount_safety_loop() {
  grep -q 'for mp in run proc sys;' "$1"
}

insert_mount_safety_loop() {
  sed -i "$MOUNT_LOOP_LINE"'i\
      for mp in run proc sys;\
      do\
          if mountpoint -q "${INSTALL_DIR}/${mp}"; then\
              umount_kill "${INSTALL_DIR}/${mp}" || true\
          fi\
          if [ ! -e "${INSTALL_DIR}/${mp}" ]; then\
              mkdir -p "${INSTALL_DIR}/${mp}"\
          fi\
      done\
  ' "$1"
}

add_mount_safety_loop() {
  local os fp
  for os in $DISTRIBUTION_OSES; do
    fp="artifacts/sources/builder-debian/template_$os/distribution.sh"
    if has_mount_safety_loop "$fp"; then
      echo "mount safety loop already present in $fp"
    else
      insert_mount_safety_loop "$fp"
    fi
  done
}

main() {
  echo "1/2"
  remove_double_slash_before_tmpdir
  add_mount_safety_loop
  echo "done."
}

main "$@"
