# Aufgabe

Nach einem Neustart fragt dein Skript den Load Balancer, ob APP-01 wieder antwortet. Zum Üben
sind die Antworten vorbereitet: `$Responses` ist eine Liste, und die Antwort auf Versuch
Nummer 1 ist `$Responses[0]`, auf Versuch 2 `$Responses[1]` und so weiter.

Schreibe eine `do`-Schleife mit `until`:

1. Lies in jedem Durchlauf die Antwort für den aktuellen Versuch in `$Status` und zähle den
   Versuch in `$Attempt`. `$Attempt` beginnt bei 0.
2. Die Schleife endet, wenn `$Status` `OK` ist oder wenn `$Attempt` `$MaxAttempts` erreicht
   hat.
3. Speichere nach der Schleife in `$Succeeded`, ob der letzte `$Status` `OK` war.

Lass die Zeile mit `param` unverändert. Das Dojo übergibt darüber verschiedene Listen.
