# Aufgabe

Die Datenträgerprüfung deines Teams existiert in vier Kopien, eine pro Dateiserver, jede mit
einem anderen fest eingetippten Namen und Schwellwert. Du schreibst die eine Version, die
beides als Parameter nimmt.

1. Schreibe einen `param`-Block mit drei Parametern:
   - `$ComputerName`, ein Text, Standardwert `FS-01`
   - `$WarnPercent`, eine ganze Zahl, Standardwert `20`
   - `$Detailed`, ein Schalter
2. Speichere darunter `detailed` in `$Mode`, wenn der Schalter angegeben wurde, sonst
   `short`.

Das Dojo ruft dein Skript mit und ohne Argumente auf.
