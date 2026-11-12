# Aufgabe

Ein Kollege will diese sieben Befehle während der Geschäftszeit auf dem Dateiserver FS-02
ausführen und bittet dich, vorher drüberzuschauen. Führe nichts aus. Antworte allein anhand
der Namen.

```powershell
Get-SmbShare
Get-Service -Name LanmanServer
Stop-Service -Name LanmanServer
Remove-SmbShare -Name Transfer
Get-Disk
Set-Service -Name Spooler -StartupType Disabled
New-SmbShare -Name Scans -Path D:\Scans
```

1. Wie viele der sieben Befehle verändern den Server? Speichere die Zahl in `$ChangingCount`.
2. Welches Verb in der Liste liest nur? Speichere es als Text in `$ReadOnlyVerb`.
3. Auf einem Windows Server führst du `Get-Command -Verb Restart -Noun Service` aus. Es
   erscheint eine Zeile. Was steht in der Spalte Name? Speichere es als Text in
   `$RestartCommand`.
