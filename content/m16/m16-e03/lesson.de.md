# Wachsende Listen

Ein Array hat eine feste Größe. Es hat keine funktionierende Methode `Add`, und es lässt sich
nichts entfernen.

`+=` scheint trotzdem ein Element anzuhängen. In Wahrheit baut es ein neues Array, ein
Element länger, kopiert alles hinüber und wirft das alte weg. Bei zehn Servern merkt das
niemand. Bei fünfzigtausend Logzeilen verbringt das Skript seine Zeit mit Kopieren.

Muss eine Liste wachsen oder schrumpfen, nimm eine generische List. Beim Anlegen sagst du,
was sie enthält:

`$Queue = [System.Collections.Generic.List[string]]::new()`

- `Add('x')` hängt ein Element an.
- `Remove('x')` entfernt das erste Element mit diesem Wert.
- `Contains('x')` antwortet mit wahr oder falsch. Es unterscheidet Groß- und
  Kleinschreibung.
- `Count` und `[0]` funktionieren wie bei einem Array.

Eine List geht in eine Pipeline wie ein Array.

## Beispiel

```powershell
$Queue = [System.Collections.Generic.List[string]]::new()
$Queue.Add('FS-01')
$Queue.Add('FS-02')
$Queue.Remove('FS-01')
$Queue.Count

$Servers = 'FS-01', 'FS-02'
$Servers += 'FS-03'
```

`Remove` gibt True aus, wenn es etwas gefunden hat. `$null = $Queue.Remove(...)` unterdrückt
das.
