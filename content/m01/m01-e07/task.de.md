# Aufgabe

Ein Administrator hat die Firma verlassen. Seine Übergabenotiz für den Dateiserver FS-02
besteht aus Kürzeln wie `gci`, `gcm`, `gal` und `gps`. Du schreibst die Dokumentation, die
die Notiz hätte sein sollen.

1. Löse die vier Aliase `gci`, `gcm`, `gal` und `gps` mit einem einzigen Aufruf auf und
   speichere das Ergebnis in `$Translation`.
2. Speichere jeden Alias, der auf `Get-ChildItem` zeigt, in `$ItemAliases`.
3. Lege für deine eigene Konsolensitzung den Alias `procs` für `Get-Process` an.
4. Rufe deinen neuen Alias auf und speichere seine Ausgabe in `$FromAlias`.
