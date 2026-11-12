# The three views

When objects reach the end of a pipeline, PowerShell has to draw them. If you say nothing
it picks a default view. Three cmdlets let you decide yourself.

- `Format-Table` draws columns. Good for comparing many objects by a few properties.
  `-AutoSize` makes the columns as narrow as the content allows.
- `Format-List` draws one property per line. Good for looking at one or two objects in
  full. `-Property *` shows every property, also the ones the default view hides.
- `Format-Wide` draws a single property in several columns. Good for a quick list of
  names. `-Column` sets how many.

All three take `-Property` to choose what is shown.

Without a format cmdlet PowerShell uses a table for objects with up to four properties and
a list for more, unless the type brings its own view.

## Example

```powershell
Get-Service | Format-Table -Property Name, Status -AutoSize
Get-Service -Name Spooler | Format-List -Property *
Get-Service | Format-Wide -Property Name -Column 4
```

Line 2 is the fastest way to see everything a single object contains.
