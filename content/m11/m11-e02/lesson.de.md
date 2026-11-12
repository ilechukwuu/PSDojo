# Warnung, Verbose und die anderen Ströme

PowerShell hat sechs Ströme. Jeder hat eine Nummer und ein Cmdlet, das hineinschreibt.

1. Erfolg: `Write-Output`, das Ergebnis.
2. Fehler: `Write-Error`. Fehler behandelt Modul 30.
3. Warnung: `Write-Warning`. Erscheint gelb mit dem Wort WARNING davor. Für Dinge, die
   Aufmerksamkeit verdienen, das Skript aber nicht anhalten.
4. Verbose: `Write-Verbose`. Standardmäßig verborgen. Für Fortschrittsnotizen, die helfen,
   wenn du verstehen musst, was ein Skript tut.
5. Debug: `Write-Debug`. Standardmäßig verborgen, für Entwickler.
6. Information: `Write-Information` und `Write-Host`.

Ob die verborgenen Ströme erscheinen, entscheiden Präferenzvariablen.
`$VerbosePreference = 'Continue'` schaltet Verbose-Meldungen für die Sitzung ein,
`'SilentlyContinue'` schaltet sie wieder aus.

Deshalb schlägt `Write-Verbose` für Fortschrittsnotizen `Write-Host`: Der Leser entscheidet.
Still im Normalbetrieb, gesprächig bei der Fehlersuche.

## Beispiel

```powershell
Write-Verbose -Message 'Reading services from APP-01'
$Count = 3
Write-Warning -Message "Stopped automatic services: $Count"
```

Zeile 1 zeigt nichts, solange Verbose nicht eingeschaltet ist. Zeile 3 zeigt immer eine
Warnung.
