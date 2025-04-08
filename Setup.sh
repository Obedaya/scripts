#!/bin/bash

echo "Get required files..."
git clone https://github.com/Obedaya/obedssetupscript
cd obedssetupscript
chmod +x setup.sh
./setup.sh -t

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
