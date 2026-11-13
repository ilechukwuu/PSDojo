# Was in der Produktion schiefgeht

Ein Aufräumskript für alte Profile bekommt einen Pflichtparameter `-ComputerName`, was gute
Praxis ist. Es wird als geplante Aufgabe registriert, und wer es registriert, vergisst das
Argument:

```powershell
powershell.exe -File D:\Scripts\Remove-OldProfile.ps1
```

Um 2 Uhr nachts fragt PowerShell nach dem fehlenden Wert, wie bei jedem Pflichtparameter.
Niemand sitzt vor dem unsichtbaren Fenster. Die Aufgabe bleibt elf Tage im Zustand "Wird
ausgeführt", und weil sie keine zweite Instanz starten darf, läuft das Aufräumen nie wieder.
Die Datenträger der Terminalserver laufen voll.

Starte unbeaufsichtigte Skripte mit `-NonInteractive`. Ein fehlender Pflichtparameter wird
dann zu einem sofortigen Fehler mit Exitcode, den die Überwachung sieht.
