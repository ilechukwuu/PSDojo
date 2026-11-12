# Was in der Produktion schiefgeht

Ein Kapazitätsskript liest die Datenträgergrößen aller Dateiserver aus einer CSV-Datei und
addiert sie:

```powershell
$Total = 0
$Total = $Row1.SizeGB + $Row2.SizeGB
```

Alles, was aus einer CSV-Datei kommt, ist Text. `'500' + '250'` ist nicht 750, sondern der
Text 500250. Der Bericht sagt, die Firma besitze eine halbe Million Gigabyte, und niemand
merkt es, bis das Speicherbudget gekürzt wird.

Werte aus Dateien, Benutzereingaben und Webdiensten sind Text, bis du sie umwandelst. Wandle
an der Grenze um, dort, wo die Daten ins Skript kommen, mit `[int]`, `[double]` oder
`[datetime]`, und rechne nur mit umgewandelten Werten.
