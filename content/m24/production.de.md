# Was in der Produktion schiefgeht

Ein Helpdesk-Werkzeug komprimiert einen Ordner, den der Techniker in ein Textfeld tippt. Um
flexibel zu bleiben, baut der Autor den Befehl als Text und führt ihn aus:

```powershell
Invoke-Expression "Compress-Archive -Path $Folder -DestinationPath D:\Out\data.zip"
```

Das funktioniert jahrelang. Dann heisst ein Ordner `D:\Data; Remove-Item D:\Shares -Recurse`.
Der Text wird als zwei Befehle ausgeführt, mit den Rechten des Werkzeugs. Dasselbe passiert,
weniger dramatisch, bei jedem Ordnernamen mit einem Leerzeichen oder Anführungszeichen.

Text, der als Code ausgeführt wird, ist das gefährlichste Konstrukt in PowerShell. Rufe das
Cmdlet direkt auf und übergib Werte als Parameter, mit Splatting, wenn die Parameter
wechseln, oder lege die Logik in einen Skriptblock. Dann bleibt ein Wert immer ein Wert.
