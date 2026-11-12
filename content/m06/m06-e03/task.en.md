# Task

A colleague sends you five lines from a script that prepares a certificate report for web
server WEB-01 and asks what they return. Predict the results without running the lines.

```powershell
$Name = '  web-01.nordwind.example '
$Expires = Get-Date -Year 2026 -Month 12 -Day 20

$Name.Trim().ToUpper()
$Name.Trim().Split('.')[1]
$Name.Trim().Replace('WEB', 'APP')
$Expires.AddDays(14).Month
$Name.Length
```

1. Store what line 4 returns in `$ResultUpper`.
2. Store what line 5 returns in `$ResultSplit`.
3. Store what line 6 returns in `$ResultReplace`.
4. Store what line 7 returns in `$ResultMonth`.
5. Store what line 8 returns in `$ResultLength`.
