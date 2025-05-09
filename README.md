# Scripts

## Features
- F√ºgt den neuen Kali gpg key hinzu
- Klont Tools aus Repos und passt automatisch IP und Port an:
    - Linpeas und Winpeas
    - PrivescCheck
    - Pentestmonkey PHP Revshell (port 5555)
    - Powershell Revshell (port 6666)
- Entpackt rockyou
- Setzt deutsches Keyboard Layout
- Installiert Browser extensions f√r Firefox (sofern Firefox auf Kali Maschine funktioniert)
- Inkludiert sind au√üerdem 2 Skripte zum nmap und gobuster scannen (Sind grad brokey)

Optional (-t: Execute at own risk -> K√nnte bei Fehlern zu sh shell f√hren xD):
- Installiert Terminator
- Installiert Ohmyzsh mit Powerlevel10k
- Installiert Hacknerdfont

## Installation
```bash
./Setup.sh
```

Options (Mit sch√∂nem ZSH und anderem Terminal Emulator(Terminator)):
```bash
./Setup.sh -t
```
