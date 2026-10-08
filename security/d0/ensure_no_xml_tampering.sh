#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${XML_DIR:-./vm-xmls}"
LIBVIRT_URI="xen:///"

XML_EDITS=(
  "s|console=hvc0| |g"
  "s|rd_NO_PLYMOUTH| |g"
  "s|rd.plymouth.enable=0| |g"
  "s|clocksource=tsc| |g"
  "s|xen_scrub_pages=0|xen_scrub_pages=1|g"
  "s|swiotlb=2048| |g"
  "s|<boot dev='cdrom'>| |g"
  "s|type='rom'|readonly='yes'|g"
  "s|<pae/>||g"
  "s|<viridian/>| |g"
  "s|<acpi/>| |g"
  #"s|mode='host-passthrough'| |g"
  "s|<feature policy='disable' name='svm'/>||g"
  "s|<feature policy='disable' name='vmx'/>|<feature policy='require' name='vmx'/>|g"
  "s|<feature policy='require' name='invtsc'/>||g"
  "s|<clock offset='utc' adjustment='reset'>|<clock>|g"
  "s|<timer name='tsc' mode='native'/>|<timer mode='native'/> |g"
  "s|<on_reboot>destroy</on_reboot>| |g"
  "s|<video>||g"
  "s|</video>||g"
  "s|<model type='vga' vram='16384' heads='1' primary='yes'/>||g"
  "s|<memballoon model='xen'/>||g"
)

domains() {
  if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
  else
    sudo virsh -c "$LIBVIRT_URI" list --all --name | grep -v '^$'
  fi
}

sed_args() {
  local e
  for e in "${XML_EDITS[@]}"; do
    printf '%s\0' -e "$e"
  done
}

dump_and_edit() {
  local args
  mapfile -d '' -t args < <(sed_args)
  # shellcheck disable=SC2024 # the dump is meant to be owned by the caller
  sudo virsh -c "$LIBVIRT_URI" dumpxml "$1" < /dev/null > "$OUT_DIR/$1.xml"
  sed -i "${args[@]}" "$OUT_DIR/$1.xml"
}

dump_every_domain() {
  mkdir -p "$OUT_DIR"
  local vm
  while read -r vm; do
    dump_and_edit "$vm"
  done < <(domains "$@")
}

main() {
  dump_every_domain "$@"
  echo "done."
}

main "$@"
