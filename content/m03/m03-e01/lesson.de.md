# Get-Help

PowerShell dokumentiert sich selbst. `Get-Help` zeigt die Hilfe zu jedem Befehl, direkt dort,
wo du arbeitest, ohne Browser.

- `Get-Help -Name Stop-Process` zeigt die Kurzfassung: was der Befehl tut und wie man ihn
  aufruft.
- `-Examples` zeigt nur die Beispiele. Das ist meist der schnellste Weg, einen Befehl zu
  lernen.
- `-Parameter Force` zeigt die Details eines Parameters. `-Parameter *` zeigt alle.
- `-Full` zeigt alles, `-Online` öffnet die aktuelle Seite im Browser.

Wie jedes Cmdlet liefert `Get-Help` ein Objekt. Du kannst es speichern und seine
Eigenschaften lesen, zum Beispiel `Name`.

Die ausführlichen Texte sind nicht immer installiert. `Update-Help` lädt sie herunter, das
braucht Internetzugang und in Windows PowerShell 5.1 eine Konsole mit erhöhten Rechten. Ohne
sie zeigt `Get-Help` trotzdem die Syntax und die Parameterdetails, denn die liest PowerShell
aus dem Befehl selbst.

## Beispiel

```powershell
Get-Help -Name Stop-Process
Get-Help -Name Stop-Process -Examples
Get-Help -Name Stop-Process -Parameter Force
```

Die dritte Zeile beantwortet eine genaue Frage: Was tut `-Force` hier eigentlich?
