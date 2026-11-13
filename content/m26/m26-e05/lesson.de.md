# Deklarieren statt prüfen

Funktionen, die geschrieben wurden, bevor ihr Autor Validierungsattribute kannte, beginnen
mit einer Wand aus `if`-Anweisungen: Ist der Name leer, liegt die Zahl im Bereich, ist der
Modus eines der erlaubten Wörter. Jede wirft einen Fehler mit einem von Hand getippten Text.

Vergleiche, was dir jeder Stil gibt.

**Handgeschriebene Prüfungen**

- laufen, nachdem die Funktion gestartet ist
- sind von aussen unsichtbar. `Get-Help` und `Get-Command` wissen nichts von ihnen
- haben Fehlertexte, die sich vom Code entfernen, wenn eine Grenze geändert wird

**Attribute**

- laufen vor dem Rumpf
- sind sichtbar: `Get-Help` zeigt die erlaubten Werte, die Tab-Vervollständigung bietet sie
  an
- erzeugen einheitliche Fehlermeldungen, die Parameter, Wert und Regel nennen

Das Umschreiben ist mechanisch. Eine Prüfung "ist es leer" wird zu `[Parameter(Mandatory)]`.
Eine Prüfung "zwischen" wird zu `[ValidateRange()]`. Eine Prüfung "eines von" wird zu
`[ValidateSet()]`. Im Rumpf bleibt der Zweck der Funktion.

## Beispiel

```powershell
function Get-ArchivePlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Share,

        [ValidateRange(30, 3650)]
        [int]$OlderThanDays = 365
    )

    [pscustomobject]@{ Share = $Share; OlderThanDays = $OlderThanDays }
}
```
