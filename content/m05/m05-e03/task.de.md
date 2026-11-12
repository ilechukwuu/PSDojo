# Aufgabe

Das Skript in deiner Übungsdatei gehört zur Speicherüberwachung von TS-03. Es enthält drei
Pipelines, und jede ist auf andere Weise kaputt.

Repariere sie:

- `$Sorted` muss alle Prozesse enthalten, sortiert nach Name.
- `$TopTwo` muss die zwei Prozesse mit dem höchsten `WorkingSet64` enthalten, den größten
  zuerst.
- `$Smallest` muss den einen Prozess mit dem niedrigsten `WorkingSet64` enthalten. Diese
  Pipeline muss auch in Windows PowerShell 5.1 laufen.

Behalte die Cmdlets und ihre Parameter. Ändere nur, wie sie verbunden sind.
