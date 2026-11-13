# Objekte zurückgeben, keinen Text

Eine Funktion, die den Text `D: is low (12 %)` zurückgibt, hat ihrem Aufrufer einen
Bärendienst erwiesen. Um nach dem Prozentwert zu sortieren oder nach knappen Volumes zu
filtern, müsste der Aufrufer den Text wieder zerschneiden.

Eine gute Funktion liefert ein **Objekt** mit einer Eigenschaft pro Tatsache. Baue es mit
`[pscustomobject]@{ ... }` als letzte Anweisung. Der Aufrufer kann dann alles tun, was die
Pipeline bietet: `Where-Object`, `Sort-Object`, `Export-Csv`, `ConvertTo-Json`. Wie das
Ergebnis auf dem Bildschirm aussieht, entscheidet, wer die Funktion aufruft, nicht die
Funktion.

**Optionale Parameter.** Einen Parameter mit Standardwert kann der Aufrufer weglassen. Nutze
das für Einstellungen mit einem sinnvollen üblichen Wert, etwa einen Schwellwert.

Halte Namen wo möglich einheitlich mit den Cmdlets: `Name`, `ComputerName`, `Path`. Die errät
man, ohne deinen Code zu lesen.

## Beispiel

```powershell
function Get-CertificateState {
    param(
        [string]$Subject,
        [int]$DaysLeft,
        [int]$WarnDays = 30
    )

    [pscustomobject]@{
        Subject  = $Subject
        DaysLeft = $DaysLeft
        Expiring = $DaysLeft -lt $WarnDays
    }
}
```
