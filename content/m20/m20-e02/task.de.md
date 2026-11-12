# Aufgabe

Ein Skript prüft Servernamen und schreibt Hostnamen um. Sein Autor hat diese Ergebnisse nicht
erwartet. Sage sie vorher. Führe nichts aus.

```powershell
'fs-02' -match 'FS-\d\d'
'FS-0234' -match 'FS-\d\d'
'FS-0234' -match '^FS-\d\d$'
'FS-02_backup' -cmatch 'fs'
'web.nordwind.example' -replace '.', '_'
'web.nordwind.example' -replace '\.', '_'
'FS-02 and FS-17' -replace '\d+', '00'
```

Speichere die sieben Ergebnisse in `$Result1` bis `$Result7`. Die ersten vier sind `$true`
oder `$false`, die letzten drei sind Texte.
