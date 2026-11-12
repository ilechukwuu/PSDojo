# Typische Variablenfehler

**Mit Text rechnen.** Zwei Texte werden zusammengefügt statt addiert. Das Ergebnis sieht wie
eine Zahl aus, nur viel zu groß. Wandle um, bevor du rechnest.

**Ein Cast, der nicht gehen kann.** `[int]$Count = 'twelve'` bricht mit der Meldung ab, dass
der Wert nicht in System.Int32 umgewandelt werden kann. Falsch sind die Daten, nicht der
Cast.

**Ein vertippter Variablenname.** `$ServerNmae` ist für PowerShell kein Fehler. Es ist eine
andere Variable, die nie jemand gefüllt hat, also `$null`, und in einem Text wird daraus
nichts. Das Skript läuft weiter und erzeugt `Server: ` ohne etwas dahinter.

Der letzte ist der häufigste Fehler im ganzen Scripting. Zwei Dinge schützen dich: Lass den
Editor Variablennamen mit Tab vervollständigen, statt sie zu tippen, und später in diesem
Kurs `Set-StrictMode`, das die Nutzung einer nicht gesetzten Variablen zum Fehler macht.

## Beispiel

```powershell
$ServerName = 'FS-02'
"Server: $ServerNmae"

"Server: $ServerName"
```

Zeile 2 gibt wegen der vertauschten Buchstaben `Server: ` aus. Zeile 4 gibt `Server: FS-02`
aus.
