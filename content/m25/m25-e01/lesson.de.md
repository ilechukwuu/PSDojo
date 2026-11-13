# Funktionen

Eine Funktion ist ein Skriptblock mit einem Namen. Einmal definiert, wird sie wie ein Cmdlet
aufgerufen.

`function Get-FreePercent { ... }`

**Der Name** folgt dem Muster der Cmdlets: ein zugelassenes Verb, ein Bindestrich, ein Nomen
im Singular. `Get-Verb` listet die zugelassenen Verben. `Get-` liefert etwas, `Set-` ändert
etwas, `Test-` antwortet mit wahr oder falsch. Wer den Namen liest, weiss, was zu erwarten
ist.

**Die Parameter** stehen in einem `param`-Block am Anfang, wie in einem Skript: Name,
optional Typ, optional Standardwert.

**Das Ergebnis** ist, was die Funktion ausgibt. Ein Wert, der allein in einer Zeile steht,
wird ausgegeben. Ein besonderes Schlüsselwort ist nicht nötig. `Write-Host` malt nur Text auf
den Bildschirm. Davon kommt nichts beim Aufrufer an, eine Funktion, die etwas liefern soll,
nutzt es also nie für das Ergebnis.

Der Aufrufer übergibt Werte über den Namen, `-FreeGB 18`, oder über die Position in der
Reihenfolge des `param`-Blocks.

## Beispiel

```powershell
function Get-UsedGB {
    param(
        [double]$SizeGB,
        [double]$FreeGB
    )

    [math]::Round($SizeGB - $FreeGB, 1)
}

$Used = Get-UsedGB -SizeGB 240 -FreeGB 18.4
```
