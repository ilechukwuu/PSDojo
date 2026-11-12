# Textfehler finden

Textfehler lösen fast nie einen Fehler aus. Das Skript läuft, und der Text stimmt nicht: Ein
Variablenname erscheint wörtlich, ein Wert fehlt, eine Datei bekommt einen merkwürdigen
Namen. Man findet sie, indem man das Ergebnis ansieht, nicht eine Fehlermeldung.

Eine kurze Checkliste für einen Text, der falsch herauskommt:

1. **Welche Anführungszeichen?** Erscheint der Variablenname selbst in der Ausgabe, steht der
   Text in einfachen Anführungszeichen.
2. **Eine Eigenschaft?** Erscheint etwas wie `@{...}` oder ein Typname, gefolgt von einem
   Punkt und einem Wort, fehlt einer Eigenschaft ihr `$( )`.
3. **Was folgt der Variablen?** Fehlt ein Wert einfach, schau auf das Zeichen nach dem
   Variablennamen. Ein Unterstrich, ein Buchstabe oder eine Ziffer ist Teil des Namens
   geworden.

Gib den Text mit F8 für sich aus, bevor du ihn für irgendetwas benutzt. Ein falsch gebauter
Dateiname oder Pfad richtet weiter unten echten Schaden an.

## Beispiel

```powershell
$Server = 'FS-02'
'Backup of $Server'
"$Server_full.bak"

"Backup of $Server"
"${Server}_full.bak"
```

Die Zeilen 2 und 3 sind die Fehler, die Zeilen 5 und 6 die reparierten Fassungen.
