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

WORDLIST="/path/to/wordlist.txt"

INPUT_FILE="scan_results.json"

DIRBUSTER_RESULTS="dirbuster_results.txt"

rm -f $DIRBUSTER_RESULTS

if [ ! -f "$WORDLIST" ]; then
  echo "Fehler: Wordliste nicht gefunden. Bitte den Pfad zur Wordliste prüfen."
  exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
  echo "Fehler: Die Eingabedatei $INPUT_FILE wurde nicht gefunden."
  exit 1
fi

cleanup() {
  echo "Abbruch erkannt! Speichern der bisherigen Ergebnisse..."
  for IP_FILE in dirbuster_*.txt; do
    [ -e "$IP_FILE" ] || continue  # Falls keine Dateien vorhanden sind
    IP=$(echo $IP_FILE | sed 's/dirbuster_//; s/.txt//')
    echo "Zwischenergebnisse für $IP speichern..."
    echo "Ergebnisse für $IP:" >> $DIRBUSTER_RESULTS
    cat "$IP_FILE" >> $DIRBUSTER_RESULTS
    echo "" >> $DIRBUSTER_RESULTS
  done
  exit 0
}

trap cleanup SIGINT SIGTERM

IPS=$(jq -r '.[] | select(.ports | test("80|443")) | .ip' $INPUT_FILE)

for IP in $IPS; do
  echo "Dirbuster-Scan für $IP..."
  gobuster dir -u http://$IP -w $WORDLIST -o "dirbuster_${IP}.txt"
  # Ergebnisse in die Hauptdatei zusammenführen
  echo "Ergebnisse für $IP:" >> $DIRBUSTER_RESULTS
  cat "dirbuster_${IP}.txt" >> $DIRBUSTER_RESULTS
  echo "" >> $DIRBUSTER_RESULTS
done

echo "Dirbuster-Scans abgeschlossen. Ergebnisse sind in $DIRBUSTER_RESULTS gespeichert."
