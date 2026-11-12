# Verhalten, das man kennen sollte

**Eine Tabelle, zwei Namen.** Weist man eine Hashtable einer zweiten Variablen zu, entsteht
keine Kopie. Beide Variablen verweisen auf dieselbe Tabelle. Eine Änderung über den einen
Namen ist über den anderen sichtbar. Dasselbe gilt für eigene Objekte und Lists. Brauchst du
eine unabhängige Kopie einer Hashtable, rufe ihre Methode `Clone()` auf.

**Fehlende Schlüssel sind still.** `$Table['nope']` liefert `$null`, keinen Fehler. Ein
Tippfehler im Schlüssel sieht deshalb aus wie ein leerer Wert.

**Count gehört der Tabelle.** `$Table.Count` ist die Zahl der Paare. Einen Schlüssel, der
selbst Count heißt, liest man mit `$Table['Count']`.

**Reihenfolge.** `[pscustomobject]` und `[ordered]@{ }` behalten die geschriebene
Reihenfolge. Ein einfaches `@{ }` verspricht keine.

## Beispiel

```powershell
$A = @{ Site = 'Kiel' }
$B = $A
$B.Site = 'Hamburg'
$A.Site

$C = $A.Clone()
$C.Site = 'Bremen'
$A.Site
```

Zeile 4 liefert Hamburg: `$A` und `$B` sind dieselbe Tabelle. Zeile 8 liefert weiter
Hamburg, weil `$C` eine Kopie ist.
