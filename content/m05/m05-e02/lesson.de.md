# Wie Objekte fließen

Eine Pipeline wartet nicht, bis der erste Befehl fertig ist. Sobald der erste Befehl ein
Objekt liefert, wandert es zum zweiten Befehl und dann zum dritten. Das nennt man Streaming.
Es hält den Speicherbedarf niedrig und erlaubt `Select-Object -First 1`, die ganze Pipeline
früh zu beenden.

Manche Befehle können nicht streamen. `Sort-Object` muss jedes Objekt gesehen haben, bevor
es das erste freigibt. Es sammelt also alles und reicht es erst dann weiter.

Für dein Ergebnis heißt das: Jeder Befehl sieht nur, was der Befehl davor durchgelassen hat.

- Sortieren, dann die ersten zwei nehmen: die zwei größten von allem.
- Die ersten zwei nehmen, dann sortieren: nur die zwei, die zufällig zuerst kamen, sortiert.

Überrascht dich eine Pipeline, schneide sie nach dem ersten Befehl ab, sieh dir das Ergebnis
an und hänge dann den nächsten Befehl an.

## Beispiel

```powershell
Get-ChildItem -Path D:\Logs | Sort-Object -Property Length -Descending | Select-Object -First 1
Get-ChildItem -Path D:\Logs | Select-Object -First 1 | Sort-Object -Property Length -Descending
```

Zeile 1 liefert die größte Datei. Zeile 2 liefert die Datei, die zufällig zuerst kam.
