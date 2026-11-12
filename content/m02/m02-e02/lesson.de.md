# Kommentare und Regionen

Ein Skript wird viel öfter gelesen als geschrieben. Kommentare sagen dem Leser, was der Code
nicht sagen kann: warum es ihn gibt und worauf zu achten ist.

- `#` beginnt einen Kommentar bis zum Zeilenende.
- `<#` und `#>` umschließen einen Blockkommentar über mehrere Zeilen. Ein Blockkommentar ganz
  oben ist der übliche Platz für Zweck und Autor.
- `#region Name` und `#endregion` markieren einen Abschnitt. Beide Editoren zeigen daneben
  einen kleinen Pfeil, mit dem du den Abschnitt einklappst. PowerShell selbst ignoriert die
  beiden Marken, es sind Kommentare.

Schreibe `#region` ohne Leerzeichen nach der Raute, sonst klappt der Editor nicht ein.

In beiden Editoren öffnet Strg+J eine Liste von Snippets, fertigen Bausteinen wie einem
Blockkommentar oder einer Region.

## Beispiel

```powershell
<#
Purpose: Morning check for PRN-01
Author:  Service desk
#>

#region Settings
$ServerName = 'PRN-01'   # the print server
#endregion
```

Der Kopf sagt, wozu die Datei da ist. Die Region fasst die Einstellungen zusammen.
