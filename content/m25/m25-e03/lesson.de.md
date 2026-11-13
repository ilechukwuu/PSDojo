# Das Ergebnis einer Funktion

Drei Regeln unterscheiden sich von den meisten anderen Sprachen.

**Alles, was ausgegeben wird, wird zurückgegeben.** Nicht nur die letzte Zeile. Jede
Anweisung, deren Wert nicht zugewiesen oder verworfen wird, landet im Ergebnis. Der
klassische Fall ist eine Methode, die etwas liefert, wonach du nicht gefragt hast:
`$List.Add('x')` an einer `ArrayList` liefert den Index des neuen Eintrags. Drei solche
Aufrufe legen 0, 1 und 2 in dein Ergebnis. Verwirf unerwünschte Werte mit `$null = ...`.

**`return` beendet nur die Funktion.** `return $Value` gibt den Wert aus und geht. Es ersetzt
nicht, was davor ausgegeben wurde. Ein blankes `return` ist nützlich, um früh auszusteigen.

**Aufrufe nutzen Leerzeichen.** `Get-Thing(1, 2)` übergibt nicht zwei Argumente. Die Klammern
und das Komma bauen ein Array, und dieses Array geht an den ersten Parameter. Der zweite
bleibt leer. Schreibe `Get-Thing 1 2`, oder besser `Get-Thing -First 1 -Second 2`.

## Beispiel

```powershell
function Get-ServerList {
    $List = New-Object -TypeName System.Collections.ArrayList
    $null = $List.Add('FS-01')
    $null = $List.Add('FS-02')
    $List
}

$Servers = Get-ServerList
```

Ohne die zwei `$null =` hätte das Ergebnis vier Einträge.
