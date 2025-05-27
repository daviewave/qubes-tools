#!/bin/bash

cfg_dir=/etc/security

echo -e "-:ALL:ALL" > $cfg_dir/access.conf

echo -e "\naudit" >> $cfg_dir/faillock.conf

echo "done."
