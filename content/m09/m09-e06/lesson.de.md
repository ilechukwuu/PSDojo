# Ein Durchgang statt vieler

Ein häufiges Muster in Berichten: Daten holen, nach einem Wert filtern und zählen, wieder
holen, nach dem nächsten Wert filtern und zählen. Bei drei Statuswerten sind das drei Abrufe
und drei Filter, und die Zahlen passen womöglich nicht einmal zusammen, wenn sich
zwischendurch etwas geändert hat.

`Group-Object` erledigt dasselbe in einem Durchgang. Es liest die Daten einmal und gibt dir
für jeden vorkommenden Wert eine Gruppe, jede mit ihrem `Count`.

Um an eine bestimmte Gruppe zu kommen, filtere die Gruppen nach ihrem `Name`:

`($Groups | Where-Object { $_.Name -eq 'Stopped' }).Count`

Es gibt einen zweiten Vorteil. Gruppieren zeigt jeden Wert, den es wirklich gibt, auch die
unerwarteten, etwa einen Dienst im Zustand `StartPending`. Feste Filter würden ihn still
überspringen.

## Beispiel

```powershell
$Groups = Get-Service | Group-Object -Property Status
$Groups | Select-Object -Property Name, Count

($Groups | Where-Object { $_.Name -eq 'Running' }).Count
```

Zeile 1 holt einmal. Zeile 2 zeigt alle Gruppen, Zeile 4 holt eine Zahl heraus.
