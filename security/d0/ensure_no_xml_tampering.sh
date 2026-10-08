#!/bin/bash
set -euo pipefail

out_dir="${XML_DIR:-./vm-xmls}"

if [ $# -gt 0 ]; then
  vms=("$@")
else
  mapfile -t vms < <(sudo virsh -c xen:/// list --all --name | grep -v '^$')
fi

edits=(
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

sed_args=()
for e in "${edits[@]}"; do
  sed_args+=(-e "$e")
done

mkdir -p "$out_dir"
for vm in "${vms[@]}"; do
  # shellcheck disable=SC2024 # the dump is meant to be owned by the caller
  sudo virsh -c xen:/// dumpxml "$vm" > "$out_dir/$vm.xml"
  sed -i "${sed_args[@]}" "$out_dir/$vm.xml"
done

echo "done."
