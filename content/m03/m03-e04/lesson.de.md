# Vom Fehler zur Hilfe

Die meisten Parameterfehler entstehen durch Raten. Ein Name klingt plausibel, PowerShell
antwortet, dass kein passender Parameter gefunden wurde, und das Skript bricht ab.

Rate kein zweites Mal. Frage nach:

- `Get-Command -Name Get-Alias -Syntax` gibt jeden Parameter in einer Zeile aus.
- `Get-Help -Name Get-Alias -Parameter *` listet jeden Parameter mit seinen Details.
- Im Editor: Bindestrich tippen und Tab oder Strg+Leertaste drücken zeigt die echten Namen.

Parameternamen folgen Konventionen, deshalb kann man oft richtig raten: `-Name`, `-Path`,
`-Filter`, `-Force`, `-Recurse` bedeuten überall dasselbe. Eine Konvention ist aber keine
Garantie, und ähnliche Cmdlets nennen dieselbe Idee manchmal unterschiedlich.

PowerShell akzeptiert einen abgekürzten Namen, solange er eindeutig ist. `-Rec` funktioniert
also für `-Recurse`. Beim Tippen in der Konsole ist das in Ordnung. In einem Skript schreibst
du den vollen Namen.

## Beispiel

```powershell
Get-Alias -Cmdlet Get-ChildItem
# A parameter cannot be found that matches parameter name 'Cmdlet'.

Get-Command -Name Get-Alias -Syntax
Get-Alias -Definition Get-ChildItem
```

Die Syntax zeigt, dass der Parameter `-Definition` heißt.
