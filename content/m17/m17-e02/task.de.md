# Aufgabe

Tickets nennen nur den Server. Die Rufbereitschaft braucht den Standort und das zuständige
Team. Du baust zwei Nachschlagetabellen. Die ersten Zeilen deiner Übungsdatei enthalten den
Server des aktuellen Tickets. Lass sie unverändert.

1. Lege die Hashtable `$SiteOf` mit diesen Paaren an: `FS-01` steht in `Kiel`, `FS-02` in
   `Hamburg`, `PRN-01` in `Hamburg`.
2. Lege die Hashtable `$TeamOf` mit diesen Paaren an: `Kiel` gehört zu `Team North`,
   `Hamburg` zu `Team Elbe`.
3. Schlage den Standort von `$TicketServer` nach und speichere ihn in `$Site`.
4. Schlage das Team dieses Standorts nach und speichere es in `$Team`.
5. Speichere den Text `PRN-01 / Hamburg / Team Elbe` in `$Line`, gebaut aus den drei
   Variablen.
