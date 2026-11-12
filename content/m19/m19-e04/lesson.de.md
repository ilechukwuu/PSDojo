# Schleifen, die warten

Skripte müssen oft etwas versuchen, bis es klappt: auf einen Dienst warten, eine Anfrage
wiederholen, die in eine Zeitüberschreitung lief. Eine `do`-Schleife passt, weil der erste
Versuch immer stattfinden muss.

Die Gefahr ist eine Schleife, die nie endet. Liegt das, worauf du wartest, außerhalb deiner
Kontrolle, braucht die Schleife zwei Ausgänge, verbunden mit `-or`:

- das Ziel ist erreicht, oder
- die Versuche sind verbraucht.

Nach der Schleife prüfst du, welcher von beiden es war. Diese Prüfung ist so wichtig wie die
Schleife selbst: Ein Skript, das nach zehn gescheiterten Versuchen weitermacht, als wäre
nichts gewesen, ist schlimmer als eines, das hängt.

Zwischen echten Versuchen würdest du mit `Start-Sleep -Seconds 5` pausieren.

## Beispiel

```powershell
$Attempt = 0
$MaxAttempts = 5

do {
    $Attempt++
    $Status = (Get-Service -Name NordwindApi).Status
} until ($Status -eq 'Running' -or $Attempt -ge $MaxAttempts)

$Succeeded = $Status -eq 'Running'
```

Die Schleife endet nach höchstens fünf Durchläufen, egal was der Dienst tut.
