# Aufgabe

Das Backup von FS-02 ist letzte Nacht gescheitert. Sein Log hat mehrere hundert Zeilen. Du
durchsuchst es, statt es zu lesen. Das Dojo übergibt den Pfad der Logdatei als `$LogFile`.

1. Speichere jeden Treffer für das Muster `ERROR` in `$Errors`.
2. Speichere die Zahl dieser Treffer in `$ErrorCount`.
3. Speichere die Zeilennummer des ersten Treffers in `$FirstErrorLine`.
4. Speichere den Text aller passenden Zeilen in `$ErrorTexts`.
5. Speichere jeden Treffer für den wörtlichen Text `D:\Backup\full.bak` in `$PathHits`. Der
   Text enthält einen Punkt und Backslashes, lass ihn also nicht als regulären Ausdruck
   lesen.

Lass die Zeile mit `param` unverändert.
