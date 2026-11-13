# Gültigkeitsbereiche

Jedes Skript und jede Funktion bekommt einen eigenen **Gültigkeitsbereich** (Scope), einen
privaten Satz Variablen. Die Regeln sind kurz:

- **Lesen schaut nach aussen.** Liest eine Funktion eine Variable, die sie nicht selbst
  gesetzt hat, sucht PowerShell im aufrufenden Bereich, dann weiter aussen.
- **Schreiben bleibt innen.** Eine Zuweisung in einer Funktion erzeugt eine neue Variable im
  Bereich der Funktion. Die äussere Variable gleichen Namens behält ihren Wert. Endet die
  Funktion, sind ihre Variablen weg.
- **Blöcke sind keine Bereiche.** `if`, `foreach`, `while` und `switch` gehören zum Bereich
  um sie herum. Eine in einem `if` gesetzte Variable ist danach noch da.

Ein Präfix erreicht einen bestimmten Bereich: `$script:Count` ist die Variable auf Ebene der
Skriptdatei, `$global:Count` die der ganzen Sitzung.

Von aussen zu lesen ist bequem und macht Funktionen schwer testbar. Spätere Module reichen
stattdessen alles über Parameter hinein.

## Beispiel

```powershell
$Count = 5

function Add-Attempt {
    $Count = $Count + 1
    $Count
}

Add-Attempt
$Count
```

Die Funktion liest 5 von aussen, schreibt 6 in ihr eigenes `$Count` und gibt 6 aus. Zeile 9
gibt 5 aus.
