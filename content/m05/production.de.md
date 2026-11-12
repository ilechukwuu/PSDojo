# Was in der Produktion schiefgeht

Ein Skript soll die drei Dienste einer Fachanwendung neu starten. Der Autor baut die Liste in
einer Zeile und startet in der nächsten neu:

```powershell
Get-Service -Name Nordwind*
Restart-Service
```

Die erste Zeile gibt die Dienste nur aus. Nichts verbindet sie mit der zweiten, also hat
`Restart-Service` keine Eingabe und fragt nach einem Namen. Unbeaufsichtigt hängt das Skript
dort, bis es am Morgen jemand bemerkt.

Objekte wandern nur über das Pipe-Zeichen von einem Befehl zum nächsten. Eine neue Zeile oder
ein Semikolon beginnt einen eigenen Befehl, der vom vorherigen nichts weiß.
