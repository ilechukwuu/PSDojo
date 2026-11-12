# Positionale und abgekürzte Parameter

PowerShell erspart dir Tipparbeit auf zwei Arten.

**Positional.** `Get-ChildItem D:\Logs *.log` übergibt zwei Werte ohne Namen. PowerShell
ordnet sie nach Position zu: den ersten `-Path`, den zweiten `-Filter`. Das weißt du nur aus
der Syntax. Dort sind positionale Parameter die mit Klammern um den Namen, in ihrer
Reihenfolge.

**Abgekürzt.** `-Rec` wird für `-Recurse` akzeptiert und `-F` für `-Format`, solange nur ein
Parameter so beginnt.

Beides ist in der Konsole in Ordnung. In einem Skript sind es Fallen: Der Leser muss die
Positionen auswendig kennen, und ein abgekürzter Name kann mehrdeutig werden, wenn eine
neuere Version einen Parameter hinzufügt. Dann scheitert plötzlich ein Skript, das jahrelang
lief.

Schreibe in Skripten deshalb jeden Parameternamen aus. Die Hilfe nennt dir die Namen.

## Beispiel

```powershell
Get-Command -Name Get-ChildItem -Syntax

Get-ChildItem D:\Logs *.log -Rec
Get-ChildItem -Path D:\Logs -Filter *.log -Recurse
```

Die letzten zwei Zeilen tun dasselbe. Nur die letzte versteht man, ohne etwas nachzuschlagen.
