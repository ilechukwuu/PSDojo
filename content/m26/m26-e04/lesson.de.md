# Wohin die Teile gehören

Eine erweiterte Funktion hat einen festen Aufbau. Fehler darin erzeugen Meldungen, die auf
die falsche Stelle zeigen, es lohnt sich also, den Aufbau auswendig zu kennen.

1. `function Name {`
2. `[CmdletBinding()]`, das Attribut des `param`-Blocks. Es muss direkt vor `param` stehen.
   Unter dem Block ist es ein Syntaxfehler.
3. `param( ... )` mit den Parametern, durch Kommas getrennt. Vor jedem Parameter: seine
   Attribute, dann sein Typ.
4. Der Rumpf.

**`ValidateSet` nimmt eine Liste.** `[ValidateSet('Full', 'Log')]` hat zwei erlaubte Werte.
`[ValidateSet('Full,Log')]` hat einen, den Text `Full,Log` mit einem Komma darin. Weder
`Full` noch `Log` wird akzeptiert.

**Statustext ist kein Ergebnis.** Eine Zeile wie `"Creating plan for $Name"` im Rumpf wird
ausgegeben und landet im Ergebnis, vor dem eigentlichen Objekt. Der Aufrufer bekommt
plötzlich zwei Dinge. Meldungen gehören in `Write-Verbose`.

## Beispiel

```powershell
function Get-Quota {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Share,

        [ValidateSet('GB', 'TB')]
        [string]$Unit = 'GB'
    )

    Write-Verbose -Message "Reading quota of $Share"
    [pscustomobject]@{ Share = $Share; Unit = $Unit }
}
```
