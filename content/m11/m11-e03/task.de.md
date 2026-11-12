# Aufgabe

Ein Skript namens `check.ps1` enthält diese vier Zeilen:

```powershell
Write-Host 'Starting'
Write-Warning -Message 'Disk D: is 91 percent full'
Write-Output 'FS-02'
'FS-03'
```

Sage vorher, was passiert. Führe nichts aus.

1. Wie viele Elemente enthält `$Result` nach `$Result = .\check.ps1`? Speichere die Zahl in
   `$CapturedCount`.
2. Wie viele Elemente enthält `$Result` nach `$Result = .\check.ps1 3>&1`? Speichere die
   Zahl in `$CapturedWithWarnings`.
3. In welche Stromnummer schreibt `Write-Warning`? Speichere sie in `$WarningStream`.
4. `.\check.ps1 3> warnings.log` Welcher der vier Texte landet in der Datei? Speichere das
   erste Wort dieses Texts in `$LoggedWord`.
