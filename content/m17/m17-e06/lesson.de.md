# Warum splatten

Ein Befehl mit sechs Parametern passt nicht in eine Zeile. Dann scrollt man seitwärts,
übersieht den letzten Parameter oder bricht die Zeile mit einem Backtick am Ende um. Der
Backtick ist zerbrechlich: ein einziges Leerzeichen dahinter, und der Umbruch zählt nicht
mehr.

Splatting löst das sauber.

- Jeder Parameter steht in einer eigenen Zeile und liest sich wie eine Liste.
- Die Gleichheitszeichen stehen untereinander, ein fehlender Wert fällt auf.
- Ein Kommentar kann einen einzelnen Parameter erklären.
- Derselbe Satz lässt sich für einen zweiten Aufruf wiederverwenden oder vor dem Aufruf
  erweitern: `$Params['Recurse'] = $true`.
- Eine Änderung erscheint in der Versionskontrolle als eine geänderte Zeile.

Als Faustregel: Splatte, wenn ein Befehl mehr als drei Parameter hat oder nicht in die Zeile
passt. Benenne die Hashtable nach ihrem Zweck, nicht nur `$Params`, wenn ein Skript mehrere
hat.

## Beispiel

```powershell
$LogSearch = @{
    Path        = 'D:\Logs'
    Filter      = '*.log'
    Recurse     = $true
    File        = $true
    ErrorAction = 'Stop'
}
$Logs = Get-ChildItem @LogSearch
```
