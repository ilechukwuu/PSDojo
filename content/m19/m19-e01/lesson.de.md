# Die foreach-Anweisung

Eine Schleife wiederholt einen Codeblock. Die häufigste geht durch eine Liste und führt den
Block einmal für jedes Element aus.

`foreach ($Disk in $Disks) { ... }`

Vor jedem Durchlauf legt PowerShell das nächste Element in die Variable, die du genannt hast,
hier `$Disk`. Im Block arbeitest du mit diesem einen Element. Üblich ist ein Name im Plural
für die Liste und im Singular für die Schleifenvariable.

Drei Dinge zum Wissen:

- Alles, was der Block erzeugt, wird gesammelt. Weise das ganze `foreach` einer Variablen zu,
  und du bekommst ein Array der Ergebnisse. Das ist sauberer und schneller, als in der
  Schleife mit `+=` anzuhängen.
- Ist die Liste leer, läuft der Block gar nicht.
- Die Schleifenvariable zu ändern ändert die Liste nicht.

## Beispiel

```powershell
$Servers = 'FS-01', 'FS-02', 'FS-03'

$Lines = foreach ($Server in $Servers) {
    "Checking $Server"
}
```

Der Block läuft dreimal. `$Lines` enthält drei Texte.
