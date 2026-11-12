# Was in der Produktion schiefgeht

Ein Skript exportiert die Konfiguration aller Anwendungsserver nach JSON, damit sie sich nach
einem Neuaufbau wiederherstellen lässt:

```powershell
$Config | ConvertTo-Json | Set-Content -Path config.json
```

Die Wiederherstellung scheitert Monate später. Wo die Firewallregeln jedes Netzwerkadapters
stehen sollten, steht in der Datei `System.Collections.Hashtable`. `ConvertTo-Json` geht
standardmäßig nur zwei Ebenen tief und schreibt alles darunter als einfachen Text mit dem
Typnamen. Windows PowerShell 5.1 tut das ohne jede Warnung.

Gib immer `-Depth` mit einem Wert an, der deine Daten abdeckt, und teste eine Sicherung,
indem du sie zurückliest, nicht indem du prüfst, dass die Datei existiert.
