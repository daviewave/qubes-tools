#!/bin/bash

./check_env.sh
iif [ $? -eq 1 ]; then
  exit 1
fi

echo "(1/8) cloning builderv2 git repo..."

git clone https://github.com/QubesOS/qubes-builderv2.git /home/user/qubes-builderv2
sudo mv /home/user/qubes-builderv2 /opt

echo "(1/8) done."
