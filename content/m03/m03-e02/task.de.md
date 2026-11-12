# Aufgabe

Für ein Runbook sollst du erklären, wie zwei Cmdlets aufgerufen werden. Hier ist ihre Syntax.
Führe nichts aus, antworte anhand der Diagramme.

```powershell
Restart-Service [-Name] <string[]> [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
Get-EventLog [-LogName] <string> [-Newest <int>] [-After <datetime>] [-EntryType <string[]>] [<CommonParameters>]
```

1. Welcher Parameter von `Restart-Service` muss immer einen Wert bekommen? Speichere seinen
   Namen ohne Bindestrich als Text in `$RequiredParameter`.
2. Wie viele der gezeigten Parameter von `Restart-Service` sind Schalter? Speichere die Zahl
   in `$SwitchCount`. Zähle die Common Parameters nicht mit.
3. Welcher Parameter von `Get-EventLog` nimmt mehrere Werte an? Speichere seinen Namen in
   `$ListParameter`.
4. Ist dieser Aufruf gültig: `Get-EventLog System -Newest 10`? Speichere `$true` oder
   `$false` in `$CallIsValid`.
