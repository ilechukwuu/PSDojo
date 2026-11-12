# Aufgabe

Eine Berichtsmail zeigt merkwürdige Texte. Du siehst dir die Zeilen an, die sie bauen. Sage
den genauen Text vorher, den jede Zeile erzeugt. Führe nichts aus.

```powershell
$Server = 'PRN-01'
$Queue = [pscustomobject]@{ Jobs = 14 }

"Server: $Server"
'Server: $Server'
"Jobs: $Queue.Jobs"
"Jobs: $($Queue.Jobs)"
"$Server_report.txt"
"$($Server.ToLower()).nordwind.example"
```

Speichere die sechs Texte in `$Text1` bis `$Text6`, in der Reihenfolge der Zeilen 4 bis 9.
Nutze für deine Antworten einfache Anführungszeichen, damit darin nichts ersetzt wird.
