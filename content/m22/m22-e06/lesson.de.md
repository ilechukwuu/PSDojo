# Pfade sind kein Text

Alte Skripte bauen Pfade mit `+` und einem Backslash, und sie finden heraus, ob eine Datei da
ist, indem sie den Ordner listen und die Liste durchsuchen. Beides funktioniert an dem Tag,
an dem es geschrieben wird.

Kleben bricht leise. Ein Ordner, der schon mit einem Backslash endet, ergibt zwei davon. Eine
leere Variable ergibt einen Pfad, der an der Wurzel des Laufwerks beginnt. Und unter
PowerShell 7 auf Linux ist ein Backslash gar kein Trennzeichen.

Einen Ordner zu listen, um eine Datei zu finden, liest jeden Eintrag dieses Ordners, für jede
Datei, nach der du fragst. In einem Ordner mit fünfzigtausend Dateien dauert das Minuten.

Die Cmdlets sagen, was du meinst:

- `Join-Path -Path $Dir -ChildPath $Name` baut den Pfad.
- `Test-Path -Path $Path` fragt, ob er da ist, ohne etwas zu listen.

Eine `foreach`-Schleife kann auch Werte zurückgeben. Was in ihr ausgegeben wird, wird
gesammelt, wenn die ganze Schleife einer Variablen zugewiesen wird. Das ersetzt eine leere
Liste mit `+=`.

## Beispiel

```powershell
$Missing = foreach ($Name in $Required) {
    $Path = Join-Path -Path $ConfigDir -ChildPath $Name
    if (-not (Test-Path -Path $Path)) {
        $Name
    }
}
```
