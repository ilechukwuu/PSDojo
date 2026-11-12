# Out-File und Out-String

Manchmal liest später ein Mensch das Ergebnis, kein Programm: eine Textdatei im Ticket, ein
Mailtext. Dann willst du genau das, was der Bildschirm zeigen würde, als Text.

- `Out-File -FilePath` schreibt es in eine Datei. Eine vorhandene Datei wird überschrieben,
  `-Append` hängt stattdessen an.
- `Out-String` liefert es als einen Text, den du in einer Variablen speichern oder in eine
  Mail setzen kannst.

Beide zeichnen für einen gedachten Bildschirm. In einem Skript ohne Fenster ist der 80 oder
120 Zeichen breit, und breitere Tabellen werden abgeschnitten oder verlieren Spalten. Gib
`-Width` zur Sicherheit eine großzügige Zahl.

`Out-File` nimmt außerdem `-Encoding`. Windows PowerShell 5.1 schreibt standardmäßig UTF-16,
das viele Programme mit Lücken zwischen den Buchstaben anzeigen. PowerShell 7 schreibt UTF-8.
Mit `-Encoding utf8` verhalten sich beide gleich.

Für Daten, die ein Programm liest, nimm stattdessen `Export-Csv`. Das behandelt Modul 21.

## Beispiel

```powershell
Get-Service | Format-Table -Property Name, Status -AutoSize |
    Out-File -FilePath D:\Reports\services.txt -Encoding utf8 -Width 200

$Text = Get-Service | Format-Table -Property Name, Status | Out-String -Width 200
```
