# Wiederhole dich nicht

Dieselben drei Zeilen, kopiert und für jeden Server angepasst, sind die häufigste Form von
Skriptcode. Der Preis zeigt sich, wenn die Regel sich ändert: Jemand ändert zwei der drei
Kopien, und von da an widerspricht sich der Bericht.

Aus Kopien eine Funktion zu machen braucht drei Schritte.

1. **Finde, was sich unterscheidet** zwischen den Kopien. Das sind die Parameter.
2. **Lege, was gleich ist,** in den Funktionsrumpf.
3. **Ersetze jede Kopie** durch einen Aufruf.

Eine Regel hält die Funktion ehrlich: Sie nutzt nur ihre Parameter. Eine Funktion, die
`$Name` aus dem umgebenden Skript liest, funktioniert, solange der Aufrufer zufällig vorher
eine Variable dieses Namens setzt. Sie bricht, wenn die Funktion in eine andere Datei wandert
oder von woanders aufgerufen wird. Braucht der Rumpf einen Wert, kommt er über `param`
herein.

Ein guter Test: Könntest du die Funktion allein in eine leere Konsole kopieren und aufrufen?

## Beispiel

```powershell
function Format-ShareLine {
    param([string]$Share, [int]$UserCount)

    '{0} has {1} open sessions' -f $Share, $UserCount
}

$Lines = @(
    Format-ShareLine -Share 'HR' -UserCount 12
    Format-ShareLine -Share 'Projects' -UserCount 47
)
```
