#!/bin/bash

./check_env.sh
if [ $? -eq 1 ]; then
  exit 1
fi

rm -rf /home/user/QubesIncoming



echo "(2/8) adding custom tools..."

#1, my tools
cd "${st}"
cp builders/curr.yml "${qbp}/builder.yml" 
chmod +x ${stht}/*
cp -r "${st}/helper-tools/" "${qbp}/helper-tools"
mv "${qbp}/helper-tools/generate-container-image.sh" "${qbp}/tools"

#2, additional pkgs
sudo apt install wget proxychains4

echo "(2/8) done."

