#!/bin/bash

echo "(1/8) cloning builderv2 git repo..."

git clone https://github.com/QubesOS/qubes-builderv2.git /home/user/qubes-builderv2
sudo mv /home/user/qubes-builderv2 /opt

echo "(1/8) done."
