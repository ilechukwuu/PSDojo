# Pfade zerlegen

**`Split-Path`** ist das Gegenstück zu `Join-Path`. `-Parent` liefert alles bis zum letzten
Trennzeichen, `-Leaf` das, was danach kommt. Es arbeitet nur auf dem Text. Den Pfad muss es
nicht geben.

**Dateiobjekte** aus `Get-Item` oder `Get-ChildItem` tragen die Teile fertig mit sich:

- `Name` ist der Dateiname mit Endung.
- `Extension` ist der Teil ab dem **letzten** Punkt, einschließlich des Punkts.
- `BaseName` ist der Name ohne diese Endung.
- `DirectoryName` ist der Pfad des Ordners.

Eine Datei namens `data.tar.gz` hat deshalb die Endung `.gz`.

**`Test-Path -PathType`** fragt genauer. `Container` ist nur bei einem Ordner wahr, `Leaf`
nur bei einer Datei. Ein Pfad, den es gibt, der aber von der anderen Art ist, ergibt
`$false`.

**`Join-Path`** räumt auf. Endet der Ordner mit einem Trennzeichen oder beginnt der Name mit
einem, steht im Ergebnis trotzdem genau eines dazwischen.

## Beispiel

```powershell
Split-Path -Path 'D:\Shares\HR\plan.xlsx' -Parent
Split-Path -Path 'D:\Shares\HR\plan.xlsx' -Leaf

$File = Get-Item -Path 'D:\Shares\HR\plan.xlsx'
$File.BaseName
$File.Extension
```

Die Ergebnisse sind `D:\Shares\HR`, `plan.xlsx`, `plan` und `.xlsx`.
