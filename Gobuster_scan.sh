#!/bin/bash

install_gobuster() {
  echo "Gobuster wird nicht gefunden. Installation mit apt..."
  sudo apt-get update
  sudo apt-get install -y gobuster
  if [ $? -ne 0 ]; then
    echo "Fehler: Gobuster konnte nicht installiert werden. Bitte manuell prüfen."
    exit 1
  fi
}

if ! command -v gobuster &> /dev/null; then
  install_gobuster
fi

WORDLIST="/usr/share/wordlists/dirbuster/directory-list-2.3-small.txt"

INPUT_FILE="scan_results.json"

DIRBUSTER_RESULTS="gobuster_results.txt"

rm -f $DIRBUSTER_RESULTS

if [ ! -f "$WORDLIST" ]; then
  echo "Fehler: Wordliste nicht gefunden. Bitte den Pfad zur Wordliste prüfen."
  exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
  echo "Fehler: Die Eingabedatei $INPUT_FILE wurde nicht gefunden."
  exit 1
fi

IPS=$(jq -r '.[] | select(.ports | test("80|8080|443")) | .ip' $INPUT_FILE)

for IP in $IPS; do
  echo "Gobuster-Scan für $IP..."
  gobuster dir -u http://$IP -w $WORDLIST | tee -a $DIRBUSTER_RESULTS
done

echo "Gobuster-Scans abgeschlossen. Ergebnisse sind in $DIRBUSTER_RESULTS gespeichert."
