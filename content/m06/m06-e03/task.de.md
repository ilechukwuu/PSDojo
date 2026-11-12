# Aufgabe

Ein Kollege schickt dir fünf Zeilen aus einem Skript, das einen Zertifikatsbericht für den
Webserver WEB-01 vorbereitet, und fragt, was sie liefern. Sage die Ergebnisse vorher, ohne
die Zeilen auszuführen.

```powershell
$Name = '  web-01.nordwind.example '
$Expires = Get-Date -Year 2026 -Month 12 -Day 20

$Name.Trim().ToUpper()
$Name.Trim().Split('.')[1]
$Name.Trim().Replace('WEB', 'APP')
$Expires.AddDays(14).Month
$Name.Length
```

1. Speichere, was Zeile 4 liefert, in `$ResultUpper`.
2. Speichere, was Zeile 5 liefert, in `$ResultSplit`.
3. Speichere, was Zeile 6 liefert, in `$ResultReplace`.
4. Speichere, was Zeile 7 liefert, in `$ResultMonth`.
5. Speichere, was Zeile 8 liefert, in `$ResultLength`.
