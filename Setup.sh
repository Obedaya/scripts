#!/bin/bash

echo "Get required files..."

git clone https://github.com/Obedaya/obedssetupscript

cd obedssetupscript
chmod +x setup.sh

./setup.sh -t

echo "Unpacking rockyou..."
sudo zip -d /usr/share/wordlists/rockyou.txt.gz

echo "Done!"
