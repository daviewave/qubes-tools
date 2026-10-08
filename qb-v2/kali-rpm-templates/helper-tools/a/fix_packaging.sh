#!/bin/bash

# 1, remove extra '/' in /builder/mnt//tmp
echo "1/2"
mapfile -t matches < <(grep -Rl "\${INSTALL_DIR}/\${TMPDIR}" ./)
for match in "${matches[@]}"
do
  echo "removing extra '/' from path in script: $match"
  sed -i 's|\${INSTALL_DIR}/\${TMPDIR}|\${INSTALL_DIR}\${TMPDIR}|g' "$match"
done

#2, add the loop for mount safety
for os in debian ubuntu;
do
  fp="artifacts/sources/builder-debian/template_$os/distribution.sh"
  if grep -q 'for mp in run proc sys;' "./$fp"; then
    echo "mount safety loop already present in $fp"
    continue
  fi
  sed -i '141i\
      for mp in run proc sys;\
      do\
          if mountpoint -q "${INSTALL_DIR}/${mp}"; then\
              umount_kill "${INSTALL_DIR}/${mp}" || true\
          fi\
          if [ ! -e "${INSTALL_DIR}/${mp}" ]; then\
              mkdir -p "${INSTALL_DIR}/${mp}"\
          fi\
      done\
  ' ./$fp
done


echo "done."
