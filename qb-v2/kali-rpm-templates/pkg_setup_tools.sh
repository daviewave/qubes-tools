#!/bin/bash

setup_type="$1" # either a(pp) or t(emplate)
destination_vm="$2"

# === start 1
# a) setup_type_or_prompt
if [[ ! -n $setup_type  ]]; then
  read -p "are you preparing an appvm (a) or templatevm (t) ? (a/t): " setup_type
fi
# === end 1

# === start 2
# a) recreate_wrkdir
cd "$(dirname "$0")" || exit 1
wrkdir="./transfer-pkgs/${setup_type}-setup-tools"
rm -rf "${wrkdir:?}"
mkdir -p "$wrkdir"

# b) copy_type_specific_dirs
dependent_subdirs=("instructions" "config" "helper-tools")
for d in "${dependent_subdirs[@]}";
do
  tools_path="${d}/${setup_type}"
  [ -d "$tools_path" ] || continue

  wrkdir_path="${wrkdir}/${d}"
  mkdir -p "$wrkdir_path"
  cp -r "$tools_path"/. "$wrkdir_path"
done

# c) copy_builders
mkdir -p "$wrkdir/builders"
cp builders/* "$wrkdir/builders/"
# === end 2

# === start 3
# a) report_location
echo "done."
echo "setup tools available at: '$PWD/$wrkdir'"

# b) copy_to_vm_if_given
if [[ ! -n $destination_vm ]]; then
  echo "copy to setup vm with: 'qvm-copy-to-vm <setup vm> $wrkdir'"
else
  qvm-copy-to-vm "$destination_vm" "$wrkdir"
fi
# === end 3

echo "done."
