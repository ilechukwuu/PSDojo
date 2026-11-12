# Variablen und Typen

Eine Variable ist ein benannter Platz für einen Wert. Der Name beginnt mit `$`, der Wert
wird mit `=` zugewiesen. Namen unterscheiden keine Groß- und Kleinschreibung. Wähle Namen,
die sagen, was darin steckt: `$FreeGB` schlägt `$f`.

Jeder Wert hat einen Typ, und der Typ entscheidet, was du damit tun kannst. Die ersten, die
dir begegnen:

- `String`: Text, in Anführungszeichen. `'FS-02'`
- `Int32`: eine ganze Zahl. `445`
- `Double`: eine Zahl mit Nachkommastellen. Das Dezimaltrennzeichen im Code ist immer ein
  Punkt. `81.5`
- `Boolean`: `$true` oder `$false`.
- `DateTime`: ein Zeitpunkt, zum Beispiel von `Get-Date`.

Einen Typ deklarierst du nicht. Eine Variable nimmt den Typ dessen an, was du hineinlegst,
und er ändert sich, wenn du etwas anderes zuweist. `GetType().Name` sagt dir, was gerade
darin ist.

`$null` bedeutet gar nichts. Eine Variable, der nie etwas zugewiesen wurde, ist `$null`.

## Beispiel

```powershell
$Server = 'FS-02'
$Port = 445
$Server.GetType().Name
$Port.GetType().Name
```

Die Zeilen 3 und 4 liefern String und Int32.
