#!/bin/bash

setup_type="$1" # either a(pp) or t(emplate)
destination_vm="$2"

if [[ ! -n $setup_type  ]]; then
  read -p "are you preparing an appvm (a) or templatevm (t) ? (a/t): " setup_type
fi

cd "$(dirname "$0")" || exit 1
wrkdir="./transfer-pkgs/${setup_type}-setup-tools"
rm -rf "${wrkdir:?}"
mkdir -p "$wrkdir"

dependent_subdirs=("instructions" "config" "helper-tools")
for d in "${dependent_subdirs[@]}";
do
  tools_path="${d}/${setup_type}"
  [ -d "$tools_path" ] || continue

  wrkdir_path="${wrkdir}/${d}"
  mkdir -p "$wrkdir_path"
  cp -r "$tools_path"/. "$wrkdir_path"
done

mkdir -p "$wrkdir/builders"
cp builders/* "$wrkdir/builders/"

echo "done."
echo "setup tools available at: '$PWD/$wrkdir'"

if [[ ! -n $destination_vm ]]; then
  echo "copy to setup vm with: 'qvm-copy-to-vm <setup vm> $wrkdir'"
else
  qvm-copy-to-vm "$destination_vm" "$wrkdir"
fi

echo "done."
