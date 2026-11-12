# Was in der Produktion schiefgeht

Ein Einzeiler aus einem Forum wird in eine Konsole auf einem Produktivserver kopiert. Er
besteht nur aus Aliasen, deshalb liest niemand, was er wirklich tut:

```powershell
gsv | ? Status -eq Stopped | sasv
```

Ausgeschrieben steht dort `Get-Service | Where-Object Status -eq Stopped | Start-Service`.
Der Befehl startet jeden gestoppten Dienst, auch die, die absichtlich abgeschaltet wurden.

Bevor du einen fremden Befehl auf einem Server ausführst: Löse jeden Alias mit `Get-Alias`
auf, lies die Verben und halte an, sobald dort etwas anderes als `Get` steht.
