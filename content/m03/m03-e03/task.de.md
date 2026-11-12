# Aufgabe

Ein Bericht vom Dateiserver FS-02 kommt mit kaputten Umlauten an. Du vermutest die Kodierung
und willst wissen, bei welchen Cmdlets du sie steuern kannst. Bei der Gelegenheit
dokumentierst du, woher die Datei-Cmdlets stammen.

1. Speichere jedes Cmdlet, das einen Parameter namens `Encoding` hat, in `$EncodingCommands`.
   Beschränke das Ergebnis auf Cmdlets.
2. Speichere jeden Befehl des Moduls `Microsoft.PowerShell.Management` in
   `$ManagementCommands`.
3. Speichere die Namen aller Parameter von `Get-Content` in `$ContentParameters`.
4. Speichere den Namen des Moduls, aus dem `Get-Content` stammt, in `$ContentModule`.
