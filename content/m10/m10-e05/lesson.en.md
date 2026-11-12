# Data first, view last

A report often needs the same data in several shapes: a table for the mail, a list for the
ticket, a number for the subject line. The tempting way is to copy the whole pipeline for
each shape and change the last command.

That fetches the data several times. It is slow, and on a busy server the copies can
disagree with each other.

The better structure has two layers.

1. **Data.** One pipeline fetches, filters and sorts. Its result, real objects, goes into
   a variable with a telling name.
2. **Views.** Each view starts from that variable and ends with a format and an `Out-`
   cmdlet.

The data layer never contains a `Format-` cmdlet. That keeps the variable usable for
everything else too: counting, exporting, acting.

## Example

```powershell
$Stopped = Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Sort-Object -Property Name

$Table = $Stopped | Format-Table -Property Name, StartType | Out-String
$List = $Stopped | Format-List -Property Name, DisplayName | Out-String
$Count = @($Stopped).Count
```

One fetch, three results.
