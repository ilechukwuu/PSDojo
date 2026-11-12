# Aufgabe

Ein Kapazitätsskript liest zwei Werte aus einer CSV-Datei, beide kommen also als Text an. Ein
Kollege fragt, warum seine Zahlen nicht stimmen. Sage vorher, was jede Zeile liefert. Führe
nichts aus.

```powershell
$Used = '81'
$Free = '39'

$Used + $Free
[int]$Used + $Free
$Used * 2
[int]2.5
[bool]'0'
```

1. Speichere, was Zeile 4 liefert, in `$Result1`, mit dem Typ, den es wirklich hat.
2. Speichere, was Zeile 5 liefert, in `$Result2`.
3. Speichere, was Zeile 6 liefert, in `$Result3`.
4. Speichere, was Zeile 7 liefert, in `$Result4`.
5. Speichere, was Zeile 8 liefert, in `$Result5`.
