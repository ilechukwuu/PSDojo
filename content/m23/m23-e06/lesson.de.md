# Keine globalen Variablen

`$global:`-Variablen wirken wie ein einfacher Weg, ein Skript zu konfigurieren: oben setzen,
überall benutzen. Sie haben drei Preise.

- **Sie überleben das Skript.** Nach dem Lauf bleiben sie in der Sitzung. Das nächste Skript
  mit demselben Namen startet mit deinem übrig gebliebenen Wert.
- **Sie verstecken die Schnittstelle.** Niemand sieht von aussen, was das Skript braucht. Um
  es für einen anderen Ordner zu starten, musst du die Datei ändern.
- **Sie lassen sich nicht testen.** Jeder Test muss die Sitzung vorbereiten und aufräumen.

Ein `param`-Block löst alle drei. Die Werte, die bisher in der Datei standen, werden zu den
**Standardwerten**, das Skript verhält sich ohne Argumente also wie zuvor. Wer etwas anderes
braucht, übergibt es:

`.\Get-OldReport.ps1 -Path E:\Archive -Days 90`

Gib jedem Parameter einen Typ. Dann wird `-Days abc` schon beim Aufruf mit einer klaren
Meldung abgelehnt, statt irgendwo in der Mitte zu scheitern.

Variablen, die das Skript nur intern braucht, sind einfache Variablen ohne Präfix. Sie
verschwinden, wenn das Skript endet.

## Beispiel

```powershell
param(
    [string]$Path = 'D:\Reports',
    [int]$Days = 30
)

$Limit = (Get-Date).AddDays(-$Days)
Get-ChildItem -Path $Path -File | Where-Object { $_.LastWriteTime -lt $Limit }
```
