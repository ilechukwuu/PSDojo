# Ein Zwischenergebnis behalten

Manchmal brauchst du aus einer Pipeline zwei Dinge: das Endergebnis und etwas aus der Mitte.
Den ersten Befehl zweimal auszuführen ist Verschwendung, und auf einem beschäftigten Server
liefern die zwei Läufe womöglich nicht einmal dieselben Daten.

`Tee-Object` löst das. Wie ein T-Stück in einer Wasserleitung lässt es alles weiterfließen
und füllt nebenbei einen zweiten Behälter:

- `-Variable Name` speichert die Objekte in einer Variablen. Schreibe den Namen ohne
  Dollarzeichen, denn du benennst die Variable und benutzt nicht ihren Wert.
- `-FilePath` schreibt sie stattdessen in eine Datei.

Die Alternative ist, die Arbeit zu teilen: das erste Ergebnis in einer Variablen speichern
und von dieser Variablen aus eine neue Pipeline starten. Eine Variable kann genauso am Anfang
einer Pipeline stehen wie ein Befehl.

## Beispiel

```powershell
Get-Process | Tee-Object -Variable AllProcesses | Select-Object -First 1

$All = Get-Process
$All | Select-Object -First 1
```

Nach Zeile 1 enthält die Variable `$AllProcesses` jeden Prozess, obwohl am Ende nur einer
herauskam. Die Zeilen 3 und 4 erreichen dasselbe in zwei Schritten.
