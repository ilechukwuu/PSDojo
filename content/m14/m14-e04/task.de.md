# Aufgabe

Ein Überwachungswerkzeug übergibt deinem Skript einen Servernamen in unsauberer Form. Du
bereinigst ihn und schreibst den Text für das Ticket. Die ersten Zeilen deiner Übungsdatei
enthalten die Eingabe. Lass sie unverändert.

1. Entferne die Leerzeichen um `$RawName` und speichere das Ergebnis in `$Fqdn`.
2. Speichere den Teil von `$Fqdn` vor dem ersten Punkt in Großbuchstaben in `$ShortName`.
3. Speichere in `$IsInternal`, ob `$Fqdn` mit `.nordwind.example` endet.
4. Speichere einen Here-String mit genau diesen drei Zeilen in `$Body`. Setze `$ShortName`
   und `$FreeGB` ein:

```powershell
Ticket for FS-02
Drive "D:" has 12 GB free.
Please extend the volume.
```
