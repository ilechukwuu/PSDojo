# Zwei Arten, ein Skript zu starten

**Aufrufen.** `& $Path` oder einfach `.\settings.ps1` startet das Skript in einem neuen
Bereich. Seine Ausgabe kommt zu dir zurück. Seine Variablen und Funktionen sind weg, wenn es
endet. Das ist der normale Weg, ein Werkzeug zu starten.

Den Aufrufoperator `&` brauchst du, wenn der Pfad in einer Variablen steht oder Leerzeichen
enthält. Ein Text in Anführungszeichen allein würde nur als Text ausgegeben.

**Dot-Sourcing.** Ein Punkt, ein Leerzeichen, dann der Pfad: `. $Path`. Das Skript läuft in
*deinem* Bereich, als stünden seine Zeilen in deiner Datei. Seine Variablen und Funktionen
bleiben danach erhalten. So lädt ein Skript eine Datei mit gemeinsamen Einstellungen oder
Hilfsfunktionen.

Auch Dot-Sourcing liefert die Ausgabe des Skripts. Weise sie `$null` zu, wenn du nur die
Definitionen willst.

Verwechsle den Punkt des Dot-Sourcing nicht mit dem `.\` eines relativen Pfades.
`. .\settings.ps1` enthält beides.

`$PSScriptRoot` enthält den Ordner des laufenden Skripts. Nutze es, um Dateien zu finden, die
neben deinem Skript liegen, egal welcher Ordner gerade aktuell ist.

## Beispiel

```powershell
$Helpers = Join-Path -Path $PSScriptRoot -ChildPath 'Helpers.ps1'
. $Helpers

$Report = & (Join-Path -Path $PSScriptRoot -ChildPath 'Get-DiskReport.ps1') -ComputerName FS-01
```
