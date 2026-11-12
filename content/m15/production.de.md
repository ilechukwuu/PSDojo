# Was in der Produktion schiefgeht

Ein Skript liest die Ablaufdaten von Zertifikaten aus einer CSV-Datei und warnt 30 Tage
vorher:

```powershell
$Expires = [datetime]$Row.NotAfter
```

Die Datei wurde auf einem deutschen Server exportiert, die Daten sehen also aus wie
03.04.2026. Ein Cast liest immer auf amerikanische Art, Monat zuerst. Aus dem dritten April
wird der vierte März, und bei 14.03.2026 scheitert der Cast ganz. Die Hälfte der Warnungen
kommt einen Monat zu früh, die andere Hälfte nie.

Rate nie ein Datumsformat. Schreibst du Daten für Programme, schreibe Jahr-Monat-Tag. Liest
du Daten, die jemand anderes geschrieben hat, nenne den Aufbau mit `[datetime]::ParseExact`.
