# Splatting

A hashtable can carry the parameters of a command. The keys are the parameter names, the
values their values. You hand the whole set over by writing the variable with `@` instead
of `$`:

`Get-ChildItem @Params`

This is called splatting. A switch parameter gets the value `$true`.

Three things go wrong at first:

- **$ instead of @.** `Get-ChildItem $Params` passes the hashtable as one value to the
  first positional parameter. The command then complains about a strange path.
- **A key that is not a parameter.** `Recursive = $true` fails with the message that no
  parameter matches the name, exactly as if you had typed `-Recursive`.
- **A hashtable where an object was meant.** The same `@{ }` syntax builds both. For a row
  of data you need `[pscustomobject]` in front. Without it, `Select-Object` and
  `Export-Csv` see the table itself, not your values.

## Example

```powershell
$Params = @{
    Path    = 'D:\Logs'
    Filter  = '*.log'
    Recurse = $true
}
Get-ChildItem @Params
```

The call is the same as `Get-ChildItem -Path D:\Logs -Filter *.log -Recurse`.
