#!/bin/bash

cp conf/blacklist.conf /etc/modprobe.d/

update-initramfs -u

echo "done."
