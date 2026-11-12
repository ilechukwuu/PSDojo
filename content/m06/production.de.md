# Was in der Produktion schiefgeht

Ein Datenträgerbericht entnimmt den freien Platz dem Text, den die Konsole zeigt:

```powershell
$Line = Get-Volume -DriveLetter D | Out-String
$Free = $Line.Substring(62, 9)
```

Das funktioniert, bis jemand es auf einem Server mit längerer Datenträgerbezeichnung
ausführt. Die Spalten verschieben sich, `Substring` schneidet die falschen Zeichen heraus,
und der Bericht zeigt 0 GB frei auf einem gesunden Datenträger. Die Überwachung schlägt um
drei Uhr nachts Alarm.

Die Tabelle am Bildschirm ist nur ein Bild des Objekts. Spaltenbreiten ändern sich mit den
Daten, dem Fenster und der PowerShell-Version. Lies stattdessen die Eigenschaft:
`(Get-Volume -DriveLetter D).SizeRemaining` ist eine Zahl und bleibt eine.
