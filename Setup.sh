#!/bin/bash

INSTALL_ZSH=false

echo "Get required files..."
while getopts "t" opt; do
    case $opt in
      t) INSTALL_ZSH=true ;;
      \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
    esac
done

if $INSTALL_TERMINATOR; then
	git clone https://github.com/Obedaya/obedssetupscript
	cd obedssetupscript
	chmod +x setup.sh
	./setup.sh -t
fi
curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh >> ./Tools/linpeas.sh
curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/winPEASany.exe >> ./Tools/winPEAS.exe
curl -L https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/refs/heads/master/php-reverse-shell.php >> ./Tools/php-reverse-shell.php

echo "Unpacking rockyou..."
sudo gzip -d /usr/share/wordlists/rockyou.txt.gz

echo "Setting German keyboard layout..."
sudo sed -i 's/XKBLAYOUT="us"/XKBLAYOUT="de"/g' /etc/default/keyboard
sudo dpkg-reconfigure -phigh keyboard-configuration
setxkbmap de

if ! grep -q "setxkbmap de" ~/.zshrc; then
  echo "setxkbmap de" >> ~/.zshrc
fi

echo "Done!"
