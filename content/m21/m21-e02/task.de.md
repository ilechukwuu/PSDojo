# Aufgabe

Die Datenträgerüberwachung hält ihre Einstellungen in `monitor.json`. Du liest Werte daraus
und schreibst eine Ergebnisdatei. Das Dojo übergibt den Ordner als `$Folder`. Die Datei sieht
so aus:

```powershell
{
  "site": "Hamburg",
  "thresholds": { "warnPercent": 20, "criticalPercent": 10 },
  "servers": [
    { "name": "FS-01", "drives": ["C:", "D:"] },
    { "name": "FS-02", "drives": ["C:", "D:", "E:"] }
  ]
}
```

1. Lies die Datei in `$Config`.
2. Speichere den Warnschwellwert in `$WarnPercent`.
3. Speichere die Namen aller Server in `$ServerNames`.
4. Speichere die Zahl der Laufwerke des zweiten Servers in `$DriveCount`.
5. Schreibe `$Config` als JSON nach `copy.json` in `$Folder`. Nichts darf verloren gehen:
   Nutze eine Tiefe von 5 und UTF-8.

Lass die Zeile mit `param` unverändert.
