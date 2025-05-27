#!/bin/bash

echo "(4/8) adding kali gpg key and repo source...."

sudo curl https://archive.kali.org/archive-keyring.gpg -o /usr/share/keyrings/kali-archive-keyring.gpg

echo "WARNING: have to manually create and add the next line to '/etc/apt/sources.list.d/kali.list'"
echo "deb [signed-by=/usr/share/keyrings/kali-archive-keyring.gpg] https://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" 

echo "(4/8) done."
