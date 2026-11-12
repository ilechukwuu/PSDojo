# Binden über Eigenschaftsnamen

Daten aus einer CSV-Datei, einer Datenbank oder einem anderen Befehl kommen als Objekte mit
benannten Eigenschaften an. Die Bindung über Eigenschaftsnamen macht aus jedem dieser Objekte
einen Aufruf des empfangenden Befehls: Jede Eigenschaft, deren Name zu einem Parameter passt,
füllt diesen Parameter.

Deshalb sind Spaltennamen wichtig. Eine Liste mit einer Spalte `Name` lässt sich direkt in
Befehle leiten, die einen Parameter `-Name` haben. Eine Spalte `Server` nicht, obwohl
dieselbe Art von Wert darin stehen mag.

Zwei Details helfen:

- Mehrere Eigenschaften können gleichzeitig binden. Ein Objekt mit `Name` und `Value` füllt
  beide Parameter eines Befehls, der sie hat.
- Ein Parameter kann Aliase haben, und eine Eigenschaft, die zu einem Alias passt, bindet
  ebenfalls. `(Get-Command -Name Get-Process).Parameters.Name.Aliases` zeigt sie.

Eigenschaften ohne passenden Parameter werden einfach ignoriert.

`[pscustomobject]@{ Name = 'x' }` erzeugt ein kleines Objekt mit einer Eigenschaft. Modul 17
erklärt die Syntax.

## Beispiel

```powershell
$Row = [pscustomobject]@{ Name = 'spoolsv'; Site = 'Kiel' }
$Row | Get-Process
```

Die Eigenschaft `Name` füllt `-Name`. `Site` passt zu keinem Parameter und wird ignoriert.
