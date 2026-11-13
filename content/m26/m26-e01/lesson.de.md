# Erweiterte Funktionen

Ein Attribut vor dem `param`-Block ändert, was eine Funktion ist:

`[CmdletBinding()]`

Damit verhält sich die Funktion wie ein kompiliertes Cmdlet. Sie bekommt die **allgemeinen
Parameter** ohne eigenen Code: `-Verbose`, `-ErrorAction`, `-ErrorVariable`,
`-WarningAction` und weitere. Sie wird auch streng: Ein Argument, das zu keinem Parameter
passt, ist ein Fehler, statt still in `$args` zu verschwinden.

**Pflichtparameter.** `[Parameter(Mandatory)]` vor einem Parameter heisst, die Funktion kann
ohne ihn nicht laufen. Gib einem Pflichtparameter keinen Standardwert. Er würde nie benutzt.

**Statusmeldungen.** Was die Funktion gerade tut, gehört nicht in ihr Ergebnis.
`Write-Verbose` schreibt in einen eigenen Datenstrom, der standardmäßig verborgen ist. Der
Aufrufer schaltet ihn mit `-Verbose` ein. Das ist der richtige Ort für "Connecting to FS-01".

Attribute stapeln sich vor einem Parameter, jedes in eigenen eckigen Klammern, dann der Typ,
dann der Name.

## Beispiel

```powershell
function Get-PrintQueue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ComputerName,

        [string]$Queue = 'Default'
    )

    Write-Verbose -Message "Reading queue $Queue on $ComputerName"
    [pscustomobject]@{ ComputerName = $ComputerName; Queue = $Queue }
}
```
