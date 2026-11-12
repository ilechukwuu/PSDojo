# Mehr Suchwege

In Modul 1 hast du Befehle nach Verb, Noun und Name gesucht. `Get-Command` weiß über einen
Befehl mehr als den Namen, und auch danach kannst du suchen.

- `-ParameterName Encoding` findet jeden Befehl, der einen Parameter mit diesem Namen hat.
  Nützlich, wenn du weißt, was du steuern willst, aber nicht, welcher Befehl es anbietet.
- `-Module` listet, was ein Modul mitbringt. Ein Modul ist ein Paket von Befehlen. Die
  Kern-Cmdlets für Dateien, Prozesse und Dienste liegen in `Microsoft.PowerShell.Management`.
- `-CommandType Cmdlet` beschränkt das Ergebnis auf Cmdlets und lässt Aliase, Funktionen und
  Programme weg.

Ein Befehlsobjekt trägt alle Details. Die Eigenschaft `Parameters` ist eine Tabelle aller
Parameter, `Parameters.Keys` sind nur die Namen. `ModuleName` sagt, aus welchem Modul der
Befehl stammt.

Welche Module es gibt, unterscheidet sich zwischen Windows PowerShell 5.1 und PowerShell 7
und zwischen Betriebssystemen.

## Beispiel

```powershell
Get-Command -ParameterName ComputerName -CommandType Cmdlet
Get-Command -Module Microsoft.PowerShell.Management
(Get-Command -Name Get-ChildItem).Parameters.Keys
```

Die runden Klammern führen `Get-Command` zuerst aus. Der Punkt liest dann eine Eigenschaft
des Ergebnisses.
