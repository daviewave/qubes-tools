#!/bin/bash

./check_env.sh
if [ $? -eq 1 ]; then
  exit 1
fi

rm -rf /home/user/QubesIncoming

echo "(2/6) adding custom tools..."

#1, my tools
cd "$st" || exit 1
cp builders/curr.yml "${qbp}/builder.yml" 
chmod +x "${stht}"/*
mkdir -p "${qbpht}"
cp -rT "${stht}" "${qbpht}"
mv "${qbpht}/generate-container-image.sh" "${qbp}/tools/"

#2, additional pkgs
sudo apt install -y wget proxychains4

echo "(2/6) done."

