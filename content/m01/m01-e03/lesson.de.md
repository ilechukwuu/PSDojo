# Befehle finden mit Get-Command

Niemand lernt tausende Cmdlets auswendig. Man sucht sie. `Get-Command` listet die Befehle,
die auf dem Rechner verfügbar sind, an dem du gerade arbeitest. Verb-Noun macht die Suche
einfach.

- `-Noun` findet alles, was mit einer Art von Sache arbeitet.
- `-Verb` findet alles, was eine Art von Aktion ausführt.
- `-Name` versteht den Platzhalter `*`, der für beliebige Zeichen steht.

Das Ergebnis ist wieder eine Liste von Objekten, eines pro Befehl. Jedes hat die
Eigenschaften `Name`, `Verb` und `Noun`.

Welche Befehle du findest, hängt vom Rechner ab: von der PowerShell-Version, dem
Betriebssystem und den installierten Modulen. Fehlt ein Cmdlet in der Liste, ist es dort
nicht installiert.

## Beispiel

```powershell
Get-Command -Noun Service
Get-Command -Verb Stop
Get-Command -Name *-Item
```

Die erste Zeile listet alles für Dienste, die zweite alles, was etwas stoppt. Die dritte
listet jeden Befehl, dessen Name auf `-Item` endet, zum Beispiel `Copy-Item`.
