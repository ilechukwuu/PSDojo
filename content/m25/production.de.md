# Was in der Produktion schiefgeht

Ein Team hat eine Funktion `Copy-ConfigBackup` mit zwei Parametern, `$Source` und `$Target`.
Ein Wartungsskript ruft sie über die Position auf:

```powershell
Copy-ConfigBackup $BackupDir $ConfigDir
```

Monate später ordnet jemand die Parameter in der Funktion um, sodass das Ziel zuerst kommt,
"weil sich das besser liest". Der Aufruf im Wartungsskript läuft weiter ohne jeden Fehler. Er
kopiert nun die drei Wochen alte Sicherung über die produktive Konfiguration.

Positionen sind eine Bequemlichkeit beim Tippen an der Konsole. In allem, was in einer Datei
gespeichert wird, schreibst du die Parameternamen: `-Source $ConfigDir -Target $BackupDir`.
Ein Aufruf mit Namen übersteht eine Umordnung, und ein umbenannter Parameter scheitert laut,
statt das Falsche zu tun.
