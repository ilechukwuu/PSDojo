# Was in der Produktion schiefgeht

Ein Skript, das den freien Platz der Dateiserver meldet, funktioniert jedes Mal, wenn der
Administrator es an seinem Platz startet. Als geplante Aufgabe schreibt es jede Nacht einen
leeren Bericht.

Das Skript liest `$Servers`, und nichts darin setzt diese Variable je. Der Administrator
hatte sie vor Wochen in seiner Konsole gefüllt, später in seinem Profil, und das Skript hat
sie von dort stillschweigend übernommen. Die geplante Aufgabe läuft unter einem Dienstkonto
ohne Profil, die Variable ist also leer und die Schleife läuft null Mal. Kein Fehler,
Exitcode 0.

Ein Skript darf nur von dem abhängen, was über seinen `param`-Block hereinkommt oder was es
selbst erzeugt. Teste es so, wie es laufen wird: in einer neuen Konsole, gestartet mit
`powershell.exe -NoProfile -File .\script.ps1`.
