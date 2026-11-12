# Mit Daten rechnen

Ein großer Teil der Administration ist eine Frage nach Zeit. Welche Konten wurden seit 90
Tagen nicht benutzt? Welche Dateien sind älter als ein Jahr? Ein Datumsobjekt kann das selbst
beantworten.

**Ein Datum in der Vergangenheit oder Zukunft.** Die `Add`-Methoden liefern ein neues Datum:
`AddDays(30)`, `AddMonths(-3)`, `AddHours(12)`. Eine negative Zahl geht zurück. "Vor 90
Tagen" ist `AddDays(-90)`.

**Der Abstand zwischen zwei Daten.** Zieht man ein Datum von einem anderen ab, entsteht ein
TimeSpan, ein Objekt für eine Dauer. Die Eigenschaft `Days` ist die Zahl ganzer Tage,
`TotalDays` dasselbe als Kommazahl mit den Stunden.

**Vorher oder nachher.** Daten vergleicht man mit den üblichen Operatoren. Früher ist
kleiner: `$LastLogon -lt $Limit` ist wahr, wenn die Anmeldung vor dem Stichtag lag.

## Beispiel

```powershell
$Today = Get-Date
$Limit = $Today.AddDays(-90)

$LastLogon = [datetime]'2025-11-02'
$Age = $Today - $LastLogon
$Age.Days
$LastLogon -lt $Limit
```

Zeile 6 ist die Zahl der Tage seit der letzten Anmeldung. Zeile 7 sagt, ob das Konto älter
ist als der Stichtag.
