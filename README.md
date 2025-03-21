# Kali Cheatsheet

# Information Gathering

---

## Scans:

### Nmap

Aggressive:

```bash
nmap -A 127.0.0.1 -v
```

(Erzeugt sehr viel Traffic)

SYN:

```bash
nmap -sS -F 127.0.0.1 -v
```

(Schnell aber nicht umbedingt präzise dafür unwahrscheinlicher geloggt zu werden)

ACK:

```bash
nmap -sA -F 127.0.0.1 -v
```

(Paketfilter umgehen)

UDP:

```bash
nmap -sU -F 127.0.0.1 -v
```

Firewall erkennen:

```
nmap --badsum 127.0.0.1
```

Mac spoofing (Anonymisiert scan):

```
nmap --spoof-mac 00:11:22:33:44:55 127.0.0.1
```

IDS umgehen:

```
nmap -T2 -f 127.0.0.1
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

With 4 Threads

FTP:

```bash
hydra -l user -P /usr/share/wordlists/rockyou.txt ftp://127.0.0.1 -V
```

HTTP:

```bash
hydra -l user -P /usr/share/wordlists/rockyou.txt 127.0.0.1 http-post-form "/login:username=^USER^&password=^PASS^:Invalid Password!" -V
```

Paar Flags:  
 -f : Stoppt wenn PW gefunden  
\-s : Port

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
