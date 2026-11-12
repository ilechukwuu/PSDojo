# Was in der Produktion schiefgeht

Ein Aufräumskript entfernt Testkonten. Ihre Namen enthalten die Marke `.test`:

```powershell
Get-ADUser -Filter * | Where-Object { $_.SamAccountName -match '.test' } | Remove-ADUser
```

In einem regulären Ausdruck bedeutet ein Punkt ein beliebiges Zeichen. Das Muster passt auf
jeden Namen, der irgendwo nach mindestens einem anderen Zeichen die Buchstaben test enthält:
m.testa, aber auch contest1 und jtester, das Konto von Herrn Tester aus der Buchhaltung.

`-match` und `-replace` arbeiten immer mit regulären Ausdrücken. Ein Punkt, der einen Punkt
meint, wird `\.` geschrieben, und ein Muster, das auf einen ganzen Namen passen soll, braucht
`^` am Anfang und `$` am Ende. `[regex]::Escape()` maskiert einen Text, der wörtlich gemeint
ist.
