# Redirection

Each stream can be sent somewhere else with a redirection operator. The number in front
says which stream is meant.

- `> file` sends the result to a file and overwrites it. `>> file` appends.
- `2> file` sends errors there, `3> file` warnings, `4> file` verbose messages.
- `*> file` sends every stream.
- `2>$null` throws errors away. Use it sparingly: an error you cannot see is an error you
  cannot fix.
- `2>&1` merges the error stream into the result, so that a variable or a file gets both.
  `3>&1` does the same for warnings.

A variable assignment captures stream 1 and nothing else. Warnings, errors and `Write-Host`
text go past it to the screen, unless you merge them in.

`Write-Host` writes to stream 6 since PowerShell 5. In older versions it could not be
redirected at all.

## Example

```powershell
$Result = Get-ChildItem -Path D:\Reports, D:\Missing 2>$null
Get-ChildItem -Path D:\Reports, D:\Missing 2> errors.log
$All = Get-ChildItem -Path D:\Reports, D:\Missing 2>&1
```

Line 1 keeps the files and drops the error. Line 2 logs the error. Line 3 puts both into
the variable.
