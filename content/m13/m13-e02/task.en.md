# Task

A review of the disk monitoring for FS-02 turns up five expressions without parentheses.
Predict what each returns. Do not run anything.

```powershell
$Used = 80
$Total = 100

$Used + 20 / $Total
($Used + 20) / $Total
$Total - $Used -lt 25
$Used -gt 90 -or $Used -gt 70 -and $Total -eq 50
-not ($Used -gt 90)
```

Store the results of lines 4 to 8 in `$Result1` to `$Result5`.
