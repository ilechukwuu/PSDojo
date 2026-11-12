# Aufgabe

Bevor ein Wartungsskript für den Druckserver PRN-01 produktiv geht, prüfst du, wie seine
Pipelines binden. Die Hilfe zu `Stop-Service` zeigt:

```powershell
-InputObject <ServiceController[]>
    Accept pipeline input?       true (ByValue)

-Name <string[]>
    Accept pipeline input?       true (ByValue, ByPropertyName)

-Force
    Accept pipeline input?       false
```

Speichere für jede Pipeline den Namen des Parameters, der die Eingabe erhält, ohne
Bindestrich. Kann nichts binden, speichere den Text `none`.

1. `Get-Service -Name Spooler | Stop-Service` in `$BindService`
2. `'Spooler' | Stop-Service` in `$BindText`
3. Ein Objekt, das nur die Eigenschaft `Name` mit dem Wert Spooler hat, in `Stop-Service`
   geleitet, in `$BindObject`
4. Ein Objekt, das nur die Eigenschaft `Service` mit dem Wert Spooler hat, in `Stop-Service`
   geleitet, in `$BindOther`
