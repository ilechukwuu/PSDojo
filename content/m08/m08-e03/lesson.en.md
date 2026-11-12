# Combining conditions

One comparison is rarely enough. A service is only a problem when it is stopped and should
be running.

- `-and`: both sides must be true.
- `-or`: at least one side must be true.
- `-not`: turns true into false. `!` means the same.

When you mix `-and` and `-or`, use parentheses to say which belongs together. Without them
both have the same rank and are read from left to right, which is rarely what you meant.

Two operators save long chains of `-or`:

- `-like` with wildcards: `$_.Name -like 'Nordwind*'`
- `-in` with a list: `$_.Name -in $Critical` is true when the name is one of the values in
  the list. `-notin` is the opposite.

## Example

```powershell
Get-Service | Where-Object { $_.Status -eq 'Stopped' -and $_.StartType -eq 'Automatic' }

$Critical = 'Spooler', 'WinRM'
Get-Service | Where-Object { $_.Name -in $Critical }

Get-Service | Where-Object { ($_.Name -like 'SQL*' -or $_.Name -like 'MSSQL*') -and $_.Status -eq 'Running' }
```

Line 1 finds services that should run but do not.
