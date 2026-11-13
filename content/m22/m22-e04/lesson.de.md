# Kopieren, verschieben, umbenennen

`Copy-Item`, `Move-Item` und `Rename-Item` nehmen `-Path` und `-Destination` (oder
`-NewName`). Drei Fallen sind typisch, und keine hält das Skript mit einem klaren Fehler an.

**Ein Ordner wird ohne Inhalt kopiert.** `Copy-Item` auf einen Ordner kopiert den Ordner
selbst. Erst mit `-Recurse` kommt alles darin mit.

**Das Ziel existiert nicht.** `Move-Item -Destination D:\Archive` verschiebt eine Datei *in*
den Ordner, wenn es ihn gibt. Gibt es ihn nicht, wird die Datei in `Archive` *umbenannt*.
Die erste Datei wird zu einer Datei namens Archive, und jede weitere scheitert. Lege den
Ordner vorher an, mit `-Force`, damit ein vorhandener kein Fehler ist.

**Der Filter trifft nichts.** `-Filter '.log'` sucht eine Datei, die genau `.log` heißt. Das
Muster braucht den Stern: `'*.log'`. Eine Schleife über ein leeres Ergebnis tut nichts und
meldet nichts.

`-Force` beim Kopieren und Verschieben überschreibt vorhandene Ziele. Setze es bewusst ein.

## Beispiel

```powershell
$null = New-Item -Path D:\Archive\2026 -ItemType Directory -Force

Copy-Item -Path D:\Nordwind\config -Destination D:\Archive\2026\config -Recurse

Get-ChildItem -Path D:\Nordwind\logs -Filter '*.log' |
    Move-Item -Destination D:\Archive\2026
```
