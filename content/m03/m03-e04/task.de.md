# Aufgabe

Ein Auszubildender hat drei Zeilen für die Übergabedokumentation des Dateiservers FS-02
geschrieben und in jeder einen Parameternamen geraten. Jede Zeile scheitert.

Finde die echten Parameternamen mit `Get-Command -Syntax` oder `Get-Help -Parameter *` und
behebe die drei Zeilen. Ändere nur die falschen Parameternamen.

Wenn das Skript funktioniert:

- `$DirAliases` enthält die Aliase von `Get-ChildItem`.
- `$FirstThree` enthält die ersten drei Befehle mit dem Verb Get.
- `$PatchDate` enthält den Text 14.03.2026.
