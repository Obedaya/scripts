#!/bin/bash

INSTALL_ZSH=false

# Determine the package manager
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    UPDATE_CMD="sudo apt update"
    INSTALL_CMD="sudo apt install -y"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    UPDATE_CMD="sudo dnf check-update"
    INSTALL_CMD="sudo dnf install -y"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    UPDATE_CMD="sudo pacman -Sy"
    INSTALL_CMD="sudo pacman -Sy"
else
    echo "Unsupported package manager. Exiting."
    exit 1
fi

echo "Get required files..."
while getopts "t" opt; do
    case $opt in
      t) INSTALL_ZSH=true ;;
      \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
    esac
done

if $INSTALL_ZSH; then
	git clone https://github.com/Obedaya/obedssetupscript
	cd obedssetupscript
	chmod +x setup.sh
	./setup.sh -t
	cd ..
fi

echo "Getting tools"

mkdir ./Tools
curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh >> ./Tools/linpeas.sh
curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/winPEASany.exe >> ./Tools/winPEAS.exe
curl -L https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/refs/heads/master/php-reverse-shell.php >> ./Tools/php-reverse-shell.php
curl -L https://raw.githubusercontent.com/martinsohn/PowerShell-reverse-shell/refs/heads/main/powershell-reverse-shell.ps1 >> ./Tools/reverse-shell.ps1

$UPDATE_CMD

echo "Installing tldr..."

$INSTALL_CMD tldr

echo "Unpacking rockyou..."
sudo gzip -d /usr/share/wordlists/rockyou.txt.gz

echo "Setting German keyboard layout..."
sudo sed -i 's/XKBLAYOUT="us"/XKBLAYOUT="de"/g' /etc/default/keyboard
sudo dpkg-reconfigure -phigh keyboard-configuration
setxkbmap de

if ! grep -q "setxkbmap de" ~/.zshrc; then
  echo "setxkbmap de" >> ~/.zshrc
fi

echo "Installing browser extensions"

echo "-- Hacktools --"

sudo mkdir -p /etc/firefox-esr/policies

# Create policies.json with force-installed extensions
cat <<EOF | sudo tee /etc/firefox/policies/policies.json >/dev/null
{
  "policies": {
    "ExtensionSettings": {
      "wappalyzer@crunchlabz.com": {
        "installation_mode": "force_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/wappalyzer/latest.xpi"
      },
      "{f1423c11-a4e2-4709-a0f8-6d6a68c83d08}": {
        "installation_mode": "force_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/hacktools/latest.xpi"
      }
    }
  }
}
EOF

echo "Done!"
