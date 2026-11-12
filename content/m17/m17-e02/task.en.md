# Task

Tickets name only the server. The on-call engineer needs the site and the responsible team.
You build two lookup tables. The first lines of your exercise file hold the server of the
current ticket. Leave them as they are.

1. Create the hashtable `$SiteOf` with these pairs: `FS-01` is in `Kiel`, `FS-02` in
   `Hamburg`, `PRN-01` in `Hamburg`.
2. Create the hashtable `$TeamOf` with these pairs: `Kiel` belongs to `Team North`,
   `Hamburg` to `Team Elbe`.
3. Look up the site of `$TicketServer` and store it in `$Site`.
4. Look up the team of that site and store it in `$Team`.
5. Store the text `PRN-01 / Hamburg / Team Elbe` in `$Line`, built from the three
   variables.
