# Wenn die Bindung scheitert

Die Meldung ist lang, sagt aber eines: "The input object cannot be bound to any parameters
for the command either because the command does not take pipeline input or the input and its
properties do not match any of the parameters that take pipeline input."

Sie hat zwei Ursachen, und jede hat ihre eigene Lösung.

**Die Eigenschaft heißt falsch.** Die Daten stimmen, aber die Spalte heißt `Process` und der
Parameter heißt `-Name`. Benenne die Spalte dort um, wo die Daten entstehen. Später lernst
du, sie auch unterwegs mit `Select-Object` umzubenennen.

**Der Wert gehört gar nicht in die Pipe.** Nicht jeder Parameter nimmt Pipeline-Eingabe. Ein
Formattext, eine Anzahl oder ein Schalter muss als Parameter geschrieben werden.
Hineingeleitet scheitert er, oder er bindet, schlimmer noch, an einen anderen Parameter als
gemeint.

`Trace-Command -Name ParameterBinding -PSHost -Expression { ... }` zeigt jeden Schritt der
Bindung, wenn du genau sehen willst, was PowerShell versucht hat.

## Beispiel

```powershell
'yyyyMMdd' | Get-Date
# Cannot convert value "yyyyMMdd" to type "System.DateTime"

Get-Date -Format 'yyyyMMdd'
```

Der Text wurde über den Wert an `-Date` gebunden. Er gehört zu `-Format`, und das nimmt keine
Pipeline-Eingabe.
