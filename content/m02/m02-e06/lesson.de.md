# Host, Version und Edition

Dasselbe Skript kann an sehr verschiedenen Orten laufen: in der ISE, im Terminal von VS
Code, in einem einfachen Konsolenfenster oder unbeaufsichtigt als geplante Aufgabe. Das
Programm, in dem PowerShell läuft, heißt Host. Verhält sich ein Skript auf zwei Rechnern
unterschiedlich, ist die erste Frage immer, wo es lief.

PowerShell beantwortet das selbst mit zwei automatischen Variablen:

- `$Host.Name` ist der Name des Host-Programms.
- `$PSVersionTable` enthält die Versionsangaben. Die Eigenschaft `PSVersion` ist die Version,
  `PSVersion.Major` ihre erste Zahl. Die Eigenschaft `PSEdition` ist die Edition.

Die Edition unterscheidet die beiden Produktlinien: `Desktop` ist Windows PowerShell 5.1,
`Core` ist PowerShell 6 und neuer, also auch PowerShell 7.

Der Punkt hinter einer Variablen liest eine Eigenschaft des Objekts. Ab Modul 6 benutzt du
das überall.

## Beispiel

```powershell
$Host.Name
$PSVersionTable.PSVersion
$PSVersionTable.PSVersion.Major
```

In der ISE gibt die erste Zeile `Windows PowerShell ISE Host` aus. Im Terminal von VS Code
gibt sie `Visual Studio Code Host` aus.
