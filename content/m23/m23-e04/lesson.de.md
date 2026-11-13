# Ausführungsrichtlinie

Unter Windows entscheidet die Ausführungsrichtlinie, ob PowerShell Skriptdateien überhaupt
startet. Die üblichen Werte:

- `Restricted`: keine Skripte. Standard auf Windows-Clients.
- `RemoteSigned`: lokale Skripte laufen, heruntergeladene brauchen eine Signatur. Standard
  auf Windows Server.
- `AllSigned`: jedes Skript braucht eine vertrauenswürdige Signatur.
- `Bypass`: nichts wird blockiert.

Die Richtlinie lässt sich an fünf Stellen setzen. `Get-ExecutionPolicy -List` zeigt sie in
der Rangfolge: `MachinePolicy` und `UserPolicy` (beide per Gruppenrichtlinie gesetzt),
`Process`, `CurrentUser`, `LocalMachine`. Die erste, die nicht `Undefined` ist, gewinnt.
Deshalb scheint `Set-ExecutionPolicy` auf einem per Gruppenrichtlinie verwalteten Rechner
nichts zu bewirken.

Eine heruntergeladene Datei trägt eine Markierung. `Unblock-File` entfernt sie, nachdem du
das Skript gelesen hast.

Die Ausführungsrichtlinie ist ein Sicherheitsgurt gegen Versehen, keine Sicherheitsgrenze.
Jeder kann den Inhalt eines Skripts in die Konsole einfügen. Unter Linux und macOS meldet
PowerShell 7 immer `Unrestricted`, und die Richtlinie lässt sich nicht ändern.

## Beispiel

```powershell
Get-ExecutionPolicy -List

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
