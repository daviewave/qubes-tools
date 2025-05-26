 #!/bin/bash

./check_env.sh
if [ $? -eq 1 ]; then
  exit 1
fi

echo "(4/6) adding kali gpg key and repo source...."

#1,
sudo rm -rf /etc/proxychains4.conf
sudo cp "${st}/config/proxychains.conf" /etc

#2,
sudo proxychains4 wget https://archive.kali.org/archive-keyring.gpg -O "${archive_keyring}/kali-archive-keyring.gpg"

#3,
echo -e '\n\n'
echo -e '!!!!WARNING!!!! have to manually create and add the next line to /etc/apt/sources.list.d/kali.list: """'
echo -e 'deb [signed-by=/usr/share/keyrings/kali-archive-keyring.gpg] https://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware\n"""'

echo -e '\n(4/6) done. \n'
