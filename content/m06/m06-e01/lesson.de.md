# Get-Member

Was du am Bildschirm siehst, ist eine kleine Auswahl. Ein Prozessobjekt hat mehr als fünfzig
Eigenschaften, die Standardtabelle zeigt eine Handvoll. Um mit einem Objekt zu arbeiten,
musst du wissen, was wirklich darin steckt. Das sagt dir `Get-Member`.

Leite ein beliebiges Objekt hinein. Die Antwort hat drei Teile:

- **TypeName** ganz oben: die Art des Objekts, zum Beispiel `System.DateTime`.
- **Eigenschaften** (Property): die Daten, die das Objekt trägt, etwa `DayOfWeek`.
- **Methoden** (Method): das, was das Objekt tun kann, etwa `AddDays`.

`-MemberType Property` zeigt nur Eigenschaften, `-MemberType Method` nur Methoden.

Leitest du hundert Dateien in `Get-Member`, bekommst du eine Antwort, nicht hundert. Jeder
Typ wird einmal gemeldet.

Zusammen mit `Get-Help` und `Get-Command` ist das das dritte Werkzeug zur Orientierung: Die
Hilfe erklärt Befehle, `Get-Member` erklärt, was sie liefern.

## Beispiel

```powershell
Get-Date | Get-Member
Get-Date | Get-Member -MemberType Property
Get-Date | Get-Member -MemberType Method
```

Die erste Zeile zeigt, dass `Get-Date` ein `System.DateTime` liefert, und listet alles, was
dieser Typ anbietet.
