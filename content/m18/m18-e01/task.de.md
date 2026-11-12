# Aufgabe

Die Datenträgerüberwachung übergibt den freien Platz eines Volumes in Prozent als
`$FreePercent`. Dein Skript bewertet ihn.

Setze `$State` auf einen von drei Texten:

- `Critical`, wenn `$FreePercent` unter 10 liegt.
- `Warning`, wenn es unter 20 liegt, aber nicht unter 10.
- `OK` in jedem anderen Fall.

Setze danach `$NeedsTicket` auf `$true`, wenn der Zustand nicht `OK` ist, sonst auf `$false`.

Lass die Zeile mit `param` unverändert. Das Dojo übergibt darüber verschiedene Werte.
