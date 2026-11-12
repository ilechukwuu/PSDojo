# Eins, keins oder viele

Dieselbe Codezeile kann drei verschiedene Dinge liefern, je nachdem, wie viele Ergebnisse es
gibt.

- **Viele**: ein Array. `Count` und `[0]` tun, was du erwartest.
- **Genau eines**: das Objekt selbst, kein Array mit einem Element. `[0]` geht dann an das
  Objekt. Bei einem Text liefert es das erste Zeichen, denn ein Text ist eine Liste von
  Zeichen.
- **Keines**: `$null`. `[0]` an `$null` ist ein Fehler.

Die Kur ist `@( )`, der Array-Operator. Was darin steht, kommt als Array heraus: Mehrere
Elemente bleiben mehrere, eines wird ein Array mit einem Element, nichts wird ein leeres
Array mit `Count` 0.

Zwei Arrays lassen sich mit `+` verbinden. Das Ergebnis ist ein neues Array mit allen
Elementen.

In Windows PowerShell 5.1 ist `Count` eines einzelnen eigenen Objekts leer. Mit `@( )`
stellt sich die Frage nie.

## Beispiel

```powershell
$One = 'FS-01'
$One[0]
@($One)[0]
@($One).Count
@().Count
('FS-01', 'FS-02') + 'FS-03'
```

Die Ergebnisse sind F, FS-01, 1, 0 und ein Array mit drei Servern.
