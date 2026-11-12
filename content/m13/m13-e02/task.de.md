# Aufgabe

Ein Review der Datenträgerüberwachung für FS-02 fördert fünf Ausdrücke ohne Klammern zutage.
Sage vorher, was jeder liefert. Führe nichts aus.

```powershell
$Used = 80
$Total = 100

$Used + 20 / $Total
($Used + 20) / $Total
$Total - $Used -lt 25
$Used -gt 90 -or $Used -gt 70 -and $Total -eq 50
-not ($Used -gt 90)
```

Speichere die Ergebnisse der Zeilen 4 bis 8 in `$Result1` bis `$Result5`.
