# Aufgabe

Der Kapazitätsbericht, die Alarmmail und der Dashboard-Export müssen alle wissen, ob ein
Volume knapp ist. Du schreibst die Funktion, die alle drei nutzen können.

1. Definiere eine Funktion `Get-VolumeStatus` mit den Parametern `$Name` (Text),
   `$FreePercent` (`[double]`) und `$WarnPercent` (`[int]`, Standardwert 20).
2. Sie liefert ein Objekt mit den Eigenschaften `Name`, `FreePercent` und `Status`, in dieser
   Reihenfolge. `Status` ist der Text `low`, wenn der freie Anteil unter dem Warnwert liegt,
   sonst `ok`.
3. Rufe die Funktion für das Volume `E:` mit 35 Prozent frei auf und speichere das Ergebnis
   in `$Status`.
