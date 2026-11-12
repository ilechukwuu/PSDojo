# Syntaxdiagramme

`Get-Help` und `Get-Command -Syntax` beschreiben in einer kompakten Zeile, wie ein Befehl
aufgerufen wird. Wer sie lesen kann, braucht selten mehr.

- `-Name <string>`: ein Parameter und der Typ des Werts, den er erwartet.
- `[-Force]`: eckige Klammern um das Ganze bedeuten optional. Steht kein Typ dahinter, ist
  es ein Schalter.
- `[-Name] <string>`: Klammern nur um den Namen. Der Name darf fehlen, der Wert wird dann
  über die Position zugeordnet. Der Parameter selbst ist trotzdem Pflicht.
- `[[-Name] <string>]`: beides. Optional und positional.
- `<string[]>`: die leeren Klammern nach dem Typ bedeuten, dass mehrere Werte erlaubt sind.

Ein Befehl kann mehrere Zeilen zeigen. Jede Zeile ist ein Parametersatz, eine Kombination
von Parametern, die zusammengehören. Parameter aus zwei Zeilen lassen sich nicht mischen.

`[<CommonParameters>]` steht für Parameter, die jedes Cmdlet hat, etwa `-Verbose`.

## Beispiel

```powershell
Stop-Process [-Id] <int[]> [-PassThru] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
Stop-Process -Name <string[]> [-PassThru] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

Zwei Parametersätze: nach Id stoppen oder nach Name stoppen. `-Id` ist Pflicht, aber
positional, `-Force` ist ein optionaler Schalter.
