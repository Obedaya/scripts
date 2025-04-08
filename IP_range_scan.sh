#!/bin/bash

usage() {
  echo "Usage: $0 -r <IP_RANGE>"
  echo "  -r  IP range to scan (e.g., 192.168.1.0/24)"
  exit 1
}

while getopts "r:" opt; do
  case ${opt} in
    r )
      IP_RANGE=$OPTARG
      ;;
    \? )
      usage
      ;;
  esac
done

if [ -z "${IP_RANGE}" ]; then
  usage
fi

REACHABLE_IPS="reachable_ips.txt"
SCAN_RESULTS="scan_results.json"

rm -f $REACHABLE_IPS $SCAN_RESULTS

nmap -sn -V $IP_RANGE -oG - | awk '/Up$/{print $2}' > $REACHABLE_IPS

echo "[" >> $SCAN_RESULTS  # Beginne das JSON-Array

while IFS= read -r IP; do
  echo "Scanning $IP..."
  nmap -sS -p- --open -V $IP -oG - | awk '/Ports:/{print "{\"ip\":\"" $2 "\",\"ports\":\"" $5 "\"},"}' >> $SCAN_RESULTS
done < "$REACHABLE_IPS"

truncate -s-2 $SCAN_RESULTS
echo "]" >> $SCAN_RESULTS

echo "Scan abgeschlossen. Ergebnisse sind in $SCAN_RESULTS gespeichert."
