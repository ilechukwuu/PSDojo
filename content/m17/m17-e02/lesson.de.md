# Nachschlagetabellen

Der wertvollste Einsatz einer Hashtable ist, einen Wert in einen anderen zu übersetzen: einen
Servernamen in seinen Standort, einen Statuscode in lesbaren Text, eine Abteilung in ihre
Kostenstelle.

Ohne sie würdest du für jede einzelne Frage eine Liste filtern. Mit ihr ist die Antwort ein
Schritt, und sie bleibt ein Schritt, wenn die Tabelle zehntausend Einträge hat. Das macht
Skripte schnell, die zwei Datenquellen miteinander abgleichen.

Der Schlüssel muss nicht getippt sein. Er kann aus einer Variablen oder Eigenschaft kommen:
`$SiteOf[$Server]`.

Drei Dinge zum Merken:

- Einen Schlüssel gibt es nur einmal. Erneutes Zuweisen überschreibt.
- Das Nachschlagen eines fehlenden Schlüssels liefert `$null`. Prüfe mit `ContainsKey`, wenn
  ein fehlender Eintrag wichtig ist.
- Schlüssel werden ohne Rücksicht auf Groß- und Kleinschreibung verglichen.

## Beispiel

```powershell
$SiteOf = @{
    'FS-01' = 'Kiel'
    'FS-02' = 'Hamburg'
}

$Server = 'FS-02'
$SiteOf[$Server]
"$Server stands in $($SiteOf[$Server])"
```

Zeile 7 liefert Hamburg. In einem Text braucht das Nachschlagen `$( )`.
