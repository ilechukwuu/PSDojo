# Pfade

Drei Cmdlets tragen fast jedes Skript, das das Dateisystem anfasst.

**`Join-Path`** setzt einen Ordner und einen Namen zusammen und kümmert sich um das
Trennzeichen. Es funktioniert unter Windows und Linux gleich, ein als Text zusammengeklebter
Pfad nicht.

**`Test-Path`** antwortet mit `$true` oder `$false`, ob ein Pfad existiert. Mit
`-PathType Container` fragt es nach einem Ordner, mit `-PathType Leaf` nach einer Datei.

**`New-Item`** legt Dinge an. `-ItemType Directory` erzeugt einen Ordner, `-ItemType File`
eine leere Datei. Es liefert das neue Element zurück, weise das Ergebnis also `$null` zu,
wenn du es nicht in deiner Ausgabe willst. Einen Ordner anzulegen, den es schon gibt, ist ein
Fehler. Prüfe entweder vorher oder ergänze `-Force`, das einen vorhandenen Ordner und seinen
Inhalt in Ruhe lässt.

Um Text in eine Datei zu schreiben, erzeugt oder ersetzt `Set-Content` die Datei, und
`Add-Content` hängt an.

## Beispiel

```powershell
$LogDir = Join-Path -Path 'D:\Nordwind' -ChildPath 'Logs'

if (-not (Test-Path -Path $LogDir)) {
    $null = New-Item -Path $LogDir -ItemType Directory
}

$LogFile = Join-Path -Path $LogDir -ChildPath 'sync.log'
Add-Content -Path $LogFile -Value 'Sync started'
```
