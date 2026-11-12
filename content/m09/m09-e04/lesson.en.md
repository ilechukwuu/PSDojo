# Calculated properties

Objects rarely carry exactly the values a report needs. Sizes are in bytes, a column has the
wrong name, two properties should become one. `Select-Object` can create new properties on
the way. Such a property is written in the list after `-Property`, between the others:

`@{ Name = 'MemoryMB'; Expression = { $_.WorkingSet64 / 1MB } }`

- `Name` is what the new property is called.
- `Expression` is a script block in curly braces that calculates the value. Inside it `$_`
  is the current object, just like in `Where-Object`.

The braces around the expression are essential. Without them PowerShell calculates once,
right now, before any object has arrived.

A calculated property is also the way to rename: the expression just returns the old
property under a new name. That makes data bind to a parameter with a different name.

## Example

```powershell
Get-Process | Select-Object -Property Name,
    @{ Name = 'MemoryMB'; Expression = { [math]::Round($_.WorkingSet64 / 1MB) } },
    @{ Name = 'ProcessId'; Expression = { $_.Id } }
```

Each result has three properties: the name, the memory in megabytes and the id under a new
name.
