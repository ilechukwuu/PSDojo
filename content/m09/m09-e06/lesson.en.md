# One pass instead of many

A common pattern in reports: fetch the data, filter it for one value and count, fetch it
again, filter for the next value and count. With three status values that is three
fetches and three filters, and the numbers may not even add up if something changed in
between.

`Group-Object` does the same in one pass. It reads the data once and hands you a group for
every value that occurs, each with its `Count`.

To get at one particular group, filter the groups by their `Name`:

`($Groups | Where-Object { $_.Name -eq 'Stopped' }).Count`

There is a second advantage. Grouping shows every value that really exists, also the ones
you did not expect, such as a service in the state `StartPending`. Fixed filters would
silently skip it.

## Example

```powershell
$Groups = Get-Service | Group-Object -Property Status
$Groups | Select-Object -Property Name, Count

($Groups | Where-Object { $_.Name -eq 'Running' }).Count
```

Line 1 fetches once. Line 2 shows all groups, line 4 picks one number.
