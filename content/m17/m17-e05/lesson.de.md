# Splatting

Eine Hashtable kann die Parameter eines Befehls tragen. Die Schlüssel sind die
Parameternamen, die Werte ihre Werte. Du übergibst den ganzen Satz, indem du die Variable mit
`@` statt `$` schreibst:

`Get-ChildItem @Params`

Das nennt man Splatting. Ein Schalter bekommt den Wert `$true`.

Drei Dinge gehen anfangs schief:

- **$ statt @.** `Get-ChildItem $Params` übergibt die Hashtable als einen Wert an den ersten
  positionalen Parameter. Der Befehl beschwert sich dann über einen merkwürdigen Pfad.
- **Ein Schlüssel, der kein Parameter ist.** `Recursive = $true` scheitert mit der Meldung,
  kein Parameter passe zu dem Namen, genau als hättest du `-Recursive` getippt.
- **Eine Hashtable, wo ein Objekt gemeint war.** Dieselbe Syntax `@{ }` baut beides. Für eine
  Datenzeile brauchst du `[pscustomobject]` davor. Ohne es sehen `Select-Object` und
  `Export-Csv` die Tabelle selbst, nicht deine Werte.

## Beispiel

```powershell
$Params = @{
    Path    = 'D:\Logs'
    Filter  = '*.log'
    Recurse = $true
}
Get-ChildItem @Params
```

Der Aufruf ist derselbe wie `Get-ChildItem -Path D:\Logs -Filter *.log -Recurse`.
