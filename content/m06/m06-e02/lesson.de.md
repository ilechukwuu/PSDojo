# Eigenschaften lesen

Eine Eigenschaft liest man mit einem Punkt: das Objekt, ein Punkt, der Eigenschaftsname.
Keine Leerzeichen.

Das Objekt kann in einer Variablen stehen, oder du setzt einen Befehl in runde Klammern und
liest direkt aus seinem Ergebnis. Die Klammern sorgen dafür, dass PowerShell den Befehl
zuerst ausführt.

Der Wert einer Eigenschaft ist wieder ein Objekt mit eigenem Typ. `Length` einer Datei ist
eine Zahl, `LastWriteTime` ein Datum, und `Directory` ist ein Ordnerobjekt, das wieder
Eigenschaften hat. Punkte lassen sich also verketten: Datei, ihr Ordner, dessen Name.

Eigenschaftsnamen unterscheiden keine Groß- und Kleinschreibung. Fragst du nach einer
Eigenschaft, die es nicht gibt, kommt nichts zurück und standardmäßig auch kein Fehler. Ein
Tippfehler zeigt sich deshalb erst viel später als leerer Wert. `Get-Member` schützt dich
davor.

## Beispiel

```powershell
$File = Get-Item -Path D:\Reports\usage.csv
$File.Length
$File.LastWriteTime.Year
$File.Directory.Name

(Get-Item -Path D:\Reports\usage.csv).Extension
```

Zeile 3 liest das Datum und daraus das Jahr. Zeile 4 liest den Ordner und daraus den Namen.
