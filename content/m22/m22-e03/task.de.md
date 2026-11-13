# Aufgabe

Ein Sicherungsskript auf FS-01 baut seine Zielnamen aus den Quellpfaden. Bevor du es änderst,
willst du sicher sein, was jeder Ausdruck liefert. Die Datei
`D:\Backup\sql\nordwind-2026.tar.gz` existiert. `$File` ist das Ergebnis von `Get-Item` für
sie.

Sage die Ergebnisse vorher. Führe nichts aus.

1. `Split-Path -Path 'D:\Backup\sql\nordwind-2026.tar.gz' -Leaf` Speichere den Text in
   `$Result1`.
2. `Split-Path -Path 'D:\Backup\sql\nordwind-2026.tar.gz' -Parent` Speichere ihn in
   `$Result2`.
3. `$File.BaseName` Speichere ihn in `$Result3`.
4. `$File.Extension` Speichere ihn in `$Result4`.
5. `Test-Path -Path 'D:\Backup\sql\nordwind-2026.tar.gz' -PathType Container` Speichere
   `$true` oder `$false` in `$Result5`.
6. `Join-Path -Path 'D:\Backup\' -ChildPath '\sql'` Speichere den Text in `$Result6`.
