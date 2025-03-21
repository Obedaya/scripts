#!/bin/bash

echo "Get required files..."

git clone https://github.com/Obedaya/obedssetupscript

cd obedssetupscript
chmod +x setup.sh

./setup.sh -t

echo "Unpacking rockyou..."
gzip -d /usr/share/wordlists/rockyou.tar.gz

echo "Done!"
