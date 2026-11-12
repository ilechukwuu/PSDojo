# if, elseif, else

Bisher lief jede Zeile eines Skripts. Mit `if` entscheidet ein Skript.

Die Bedingung steht in runden Klammern, der davon abhängige Code in geschweiften. Der Block
läuft nur, wenn die Bedingung wahr ist.

- `elseif` ergänzt eine weitere Bedingung. Sie wird nur geprüft, wenn alles darüber falsch
  war.
- `else` hat keine Bedingung. Sein Block läuft, wenn darüber nichts gepasst hat.

PowerShell geht die Bedingungen von oben nach unten durch und führt den ersten Block aus,
dessen Bedingung wahr ist. Dann verlässt es das ganze Konstrukt. Die Reihenfolge zählt also:
Setze die engste Bedingung nach oben.

Was ein Block erzeugt, wird zum Ergebnis des `if`. Du kannst es deshalb direkt einer
Variablen zuweisen.

## Beispiel

```powershell
$FreePercent = 12

if ($FreePercent -lt 10) {
    $State = 'Critical'
}
elseif ($FreePercent -lt 20) {
    $State = 'Warning'
}
else {
    $State = 'OK'
}
```

12 liegt nicht unter 10, der erste Block wird also übersprungen. Es liegt unter 20, also wird
`$State` zu Warning, und der `else`-Block wird nie angesehen.
