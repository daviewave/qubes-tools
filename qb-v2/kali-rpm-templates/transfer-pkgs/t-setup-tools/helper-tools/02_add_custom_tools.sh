#!/bin/bash

echo "(2/8) adding custom tools..."

rm -rf /home/user/QubesIncoming

cd /opt/kali-rpm-templates
cp builders/curr.yml /opt/qubes-builderv2/builder.yml
chmod +x my-scripts/*
cp -r my-scripts/ /opt/qubes-builderv2/my-scripts
mv /opt/qubes-builderv2/my-scripts/generate-container-image.sh /opt/qubes-builderv2/tools

echo "(2/8) done."

