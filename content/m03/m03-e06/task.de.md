# Aufgabe

Ein Aufräumskript für den Scan-Ordner auf FS-02 ist geplant. Bevor es geschrieben wird,
prüfst du drei Parameter von `Remove-Item`. Das zeigt die Hilfe:

```powershell
-Path <string[]>
    Required?                    true
    Position?                    0
    Accept pipeline input?       true (ByValue, ByPropertyName)
    Accept wildcard characters?  true

-LiteralPath <string[]>
    Required?                    true
    Position?                    Named
    Accept wildcard characters?  false

-Recurse [<SwitchParameter>]
    Required?                    false
    Position?                    Named
    Default value                False
```

1. Ein Ordner heißt `Scans[old]`. Eckige Klammern sind Platzhalterzeichen. Welcher der beiden
   Pfadparameter nimmt diesen Namen wörtlich? Speichere seinen Namen in `$SafeParameter`.
2. Darf `-LiteralPath` ohne seinen Namen angegeben werden? Speichere `$true` oder `$false`
   in `$LiteralIsPositional`.
3. Was passiert mit Unterordnern, wenn `-Recurse` fehlt: Werden sie einbezogen? Speichere
   `$true` oder `$false` in `$IncludesSubfolders`.
