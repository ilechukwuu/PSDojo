# Parameterdetails

Die Syntaxzeile sagt, wie man einen Befehl aufruft. Zu einem einzelnen Parameter sagt
`Get-Help -Parameter` den Rest in einer kleinen Tabelle:

- **Required?** true heißt, der Befehl läuft nicht ohne Wert. Fehlt er, hält PowerShell an
  und fragt nach. Ein unbeaufsichtigtes Skript bleibt dann hängen.
- **Position?** Eine Zahl heißt, der Wert darf ohne Namen an dieser Position stehen, gezählt
  ab 0. `Named` heißt, der Name muss geschrieben werden.
- **Default value** ist das, was der Parameter benutzt, wenn du nichts angibst.
- **Accept pipeline input?** sagt, ob der Parameter Werte aus der Pipeline annimmt. Das
  brauchst du ab Modul 5.
- **Accept wildcard characters?** true heißt, `*` wird im Wert verstanden. Setze das nie
  voraus, viele Parameter nehmen einen Wert wörtlich.

## Beispiel

```powershell
Get-Help -Name Stop-Process -Parameter Id

-Id <int[]>
    Required?                    true
    Position?                    0
    Accept pipeline input?       true (ByPropertyName)
    Accept wildcard characters?  false
```

`-Id` muss angegeben werden, darf über die Position kommen, nimmt mehrere Werte, und `*`
bedeutet ihm nichts.
