#!/bin/bash

echo "Preparing debian-12 based TemplateVM to build kali linux based rpm TemplateVM's..."

./01_clone_builder_repo.sh
./02_add_custom_tools.sh
./03_import_gpg_keys.sh
./04_add_kali_list.sh
./05_big_update.sh
./06_prep_env.sh

echo "DONE."
