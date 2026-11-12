# Aufgabe

Die Anlagenverwaltung exportiert das Serverinventar als XML. Das Dojo übergibt den Ordner als
`$Folder`. Die Datei `inventory.xml` darin sieht so aus:

```powershell
<inventory>
  <server name="FS-01" site="Kiel"><ramGB>32</ramGB></server>
  <server name="FS-02" site="Hamburg"><ramGB>64</ramGB></server>
  <server name="PRN-01" site="Hamburg"><ramGB>16</ramGB></server>
</inventory>
```

1. Lies die Datei in das XML-Dokument `$Doc`.
2. Speichere die Liste der Serverelemente in `$Servers`.
3. Speichere die Namen aller Server in `$Names`.
4. Speichere die Namen der Server, deren Standort `Hamburg` ist, in `$HamburgNames`.
5. Speichere den gesamten RAM aller Server als ganze Zahl in `$TotalRam`.

Lass die Zeile mit `param` unverändert.
