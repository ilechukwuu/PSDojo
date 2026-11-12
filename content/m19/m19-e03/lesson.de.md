# for, while und do

Drei weitere Schleifen für Fälle, in denen es keine Liste zum Durchgehen gibt.

**for** zählt. Sein Kopf hat drei Teile, getrennt durch Semikolons: einen Start, eine
Bedingung und einen Schritt. `for ($i = 0; $i -lt 3; $i++)` läuft mit `$i` 0, 1 und 2.

**while** wiederholt, solange eine Bedingung wahr ist. Die Bedingung wird vor jedem Durchlauf
geprüft, der Block läuft also vielleicht nie.

**do** prüft am Ende, der Block läuft also mindestens einmal. `do { } while (...)`
wiederholt, solange die Bedingung wahr ist, `do { } until (...)` wiederholt, bis sie wahr
wird.

Zwei Schlüsselwörter ändern den Ablauf in jeder Schleife:

- `break` verlässt die Schleife sofort.
- `continue` überspringt den Rest dieses Durchlaufs und macht mit dem nächsten weiter.

## Beispiel

```powershell
for ($i = 0; $i -lt 3; $i++) { "Pass $i" }

$Free = 30
while ($Free -lt 20) { 'never runs' }

do { 'runs once' } while ($Free -lt 20)
```

Das `for` läuft dreimal. Der `while`-Block läuft nie. Der `do`-Block läuft einmal, obwohl
seine Bedingung falsch ist.
