# ForEach-Object

Die `foreach`-Anweisung braucht die ganze Liste in einer Variablen. In einer Pipeline, in der
Objekte einzeln ankommen, erledigt das Cmdlet `ForEach-Object` dieselbe Aufgabe.

Sein Block läuft einmal für jedes ankommende Objekt. Im Block ist `$_` das aktuelle Objekt,
wie bei `Where-Object`. Was der Block erzeugt, fließt in der Pipeline weiter.

Welches von beiden wann:

- **`foreach`-Anweisung**: Die Liste steht schon in einer Variablen, oder der Block ist lang.
  Sie ist die schnellere und liest sich gut.
- **`ForEach-Object`**: Du bist mitten in einer Pipeline, oder die Quelle liefert so viele
  Objekte, dass du sie nicht alle gleichzeitig im Speicher haben willst.

Verwechsle die zwei nicht. `foreach` am Anfang einer Anweisung ist die Anweisung. Nach einem
Pipe-Zeichen ist es ein Alias für das Cmdlet, und dort funktioniert die Syntax mit `in`
nicht.

## Beispiel

```powershell
Get-Service -Name Nordwind* | ForEach-Object { $_.Name.ToUpper() }

Get-ChildItem -Path D:\Logs -Filter *.log |
    ForEach-Object { "$($_.Name): $([math]::Round($_.Length / 1KB)) KB" }
```

Zeile 1 liefert die Namen in Großbuchstaben. Die Zeilen 3 und 4 liefern einen Text pro Datei.
