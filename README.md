# Scripts

## Features
- Fügt den neuen Kali gpg key hinzu
- Klont Tools aus Repos und passt automatisch IP und Port an:
    - Linpeas und Winpeas
    - PrivescCheck
    - Pentestmonkey PHP Revshell (port 5555)
    - Powershell Revshell (port 6666)
    - Exe Meterpreter Revshell (port 7777)
    - Python Revshell (port 8888)
    - Bash Revshell (port 9999)
- Entpackt rockyou
- Setzt deutsches Keyboard Layout
- Installiert Browser extensions für Firefox (sofern Firefox auf Kali Maschine funktioniert)
- Inkludiert sind außerdem 2 Skripte zum nmap und gobuster scannen (Sind grad brokey)

Optional (-t: Execute at own risk -> KÃnnte bei Fehlern zu sh shell fÃhren xD):
- Installiert Terminator
- Installiert Ohmyzsh mit Powerlevel10k
- Installiert Hacknerdfont

## Installation
```bash
./Setup.sh
```

Options (Mit schÃ¶nem ZSH und anderem Terminal Emulator(Terminator)):
```bash
./Setup.sh -t
```

ACHTUNG:
Es k�nnte sein, dass die falsche IP Adresse erkannt wurde und f�r die Revshells verwendet wurde. Deshalb vor Nutzung nachschauen ob richtige IP oder gleich im Skript.

z.B:
```bash
cat ./Tools/revshell.sh
```

Falls dies der Fall sein sollte kann man mit:
```bash
cd Tools
```

und dann:
```bash
./createreverseshells.sh <Listener IP>
```
Beispiel:
```bash
./createreverseshells.sh 192.168.1.3
```

neue Reverseshells generieren.
