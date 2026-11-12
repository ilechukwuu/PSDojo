# Was in der Produktion schiefgeht

Ein Skript soll Konten deaktivieren, die sich seit 90 Tagen nicht angemeldet haben:

```powershell
Get-ADUser -Filter * | Where-Object { $_.LastLogonDate -lt $Limit } | Disable-ADAccount
```

Dienstkonten und ganz neue Benutzer haben sich noch nie angemeldet. Ihr `LastLogonDate` ist
leer, und in PowerShell ist ein leerer Wert kleiner als jedes Datum. Der Filter lässt sie
alle durch. Am Montag sind das Backup, der SQL-Agent und zwei neue Kollegen ausgesperrt.

Ein Vergleich mit einem leeren Wert scheitert nicht, er liefert nur eine Antwort, an die du
nicht gedacht hast. Wenn du nach einer Eigenschaft filterst, entscheide bewusst, was mit
Objekten passiert, bei denen sie leer ist, und sieh dir die Liste an, bevor du sie in etwas
leitest, das verändert.
