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

### CMD: Dateien downloaden

1. curl (ab Windows 10/11)
   ```
   curl -o <Ziel-Datei> <URL>
   ```
   Beispiel:
   ```
   curl -o file.zip http://example.com/file.zip
   ```

2. bitsadmin (ältere Windows-Versionen)
   ```
   bitsadmin /transfer myDownloadJob /download /priority normal <URL> <Ziel-Datei>
   ```
   Beispiel:
   ```
   bitsadmin /transfer myjob /download /priority normal http://example.com/file.zip C:\file.zip
   ```

3. wget (muss installiert sein)
   ```
   wget <URL> -O <Ziel-Datei>
   ```
   Beispiel:
   ```
   wget http://example.com/file.zip -O file.zip
   ```

4. PowerShell aus CMD heraus
   ```
   powershell -c "Invoke-WebRequest -Uri '<URL>' -OutFile '<Ziel-Datei>'"
   ```
   Beispiel:
   ```
   powershell -c "Invoke-WebRequest -Uri 'http://example.com/file.zip' -OutFile 'file.zip'"
   ```

### CMD: Dateien hochladen

1. FTP (eingebaut)
   ```
   ftp
   open <Server>
   user <Benutzername> <Passwort>
   put <lokale_Datei>
   quit
   ```

2. SFTP (wenn installiert, z.B. mit OpenSSH)
   ```
   sftp <Benutzer>@<Server>
   put <lokale_Datei>
   exit
   ```

3. curl (HTTP POST, wenn Server es unterstützt)
   ```
   curl -F "file=@<lokale_Datei>" <Upload-URL>
   ```

4. scp (wenn installiert, z.B. mit OpenSSH)
   ```
   scp <lokale_Datei> <Benutzer>@<Server>:<Zielpfad>
   ```

### PowerShell: Dateien downloaden

1. Invoke-WebRequest
   ```
   Invoke-WebRequest -Uri "<URL>" -OutFile "<Ziel-Datei>"
   ```

2. System.Net.WebClient
   ```
   $client = New-Object System.Net.WebClient
   $client.DownloadFile("<URL>", "<Ziel-Datei>")
   ```

3. Start-BitsTransfer
   ```
   Start-BitsTransfer -Source "<URL>" -Destination "<Ziel-Datei>"
   ```

4. curl (ab PowerShell 6, Alias für Invoke-WebRequest oder echtes curl)
   ```
   curl -o "<Ziel-Datei>" <URL>
   ```

### PowerShell: Dateien hochladen

1. FTP-Upload via System.Net.WebClient
   ```
   $client = New-Object System.Net.WebClient
   $client.Credentials = New-Object System.Net.NetworkCredential("Benutzer", "Passwort")
   $client.UploadFile("ftp://<Server>/<Ziel-Datei>", "<lokale_Datei>")
   ```

2. Invoke-RestMethod (HTTP POST, z.B. für Webserver)
   ```
   Invoke-RestMethod -Uri "<Upload-URL>" -Method Post -InFile "<lokale_Datei>" -ContentType "multipart/form-data"
   ```

3. SFTP mit Posh-SSH-Modul (Modul muss installiert werden)
   ```
   New-SFTPSession -ComputerName <Server> -Credential (Get-Credential)
   Set-SFTPFile -SessionId 0 -LocalFile "<lokale_Datei>" -RemotePath "<Zielpfad>"
   ```

4. FTP-Upload via klassischem FTP-Client (aus PowerShell heraus)
   ```
   ftp -s:ftp_script.txt
   ```
   (ftp_script.txt enthält die FTP-Befehle wie oben bei CMD)
