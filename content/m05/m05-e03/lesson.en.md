# Where pipelines break

Three mistakes make a pipeline return something other than you meant, often without any
error message.

**A semicolon instead of a pipe.** `Get-Process ; Sort-Object -Property Name` is two
separate commands. The second one receives nothing.

**The wrong order.** A command can only work with what arrives. Limiting before sorting
sorts the wrong objects.

**A badly placed line break.** A long pipeline may continue on the next line, but
PowerShell must be able to tell that the line is not finished. Put the pipe character at
the end of the line. Then PowerShell knows that more follows.

PowerShell 7 also accepts a pipe at the start of the next line. Windows PowerShell 5.1 does
not: it treats the first line as complete and reports an error for the second. Write the
pipe at the end and the script runs in both.

## Example

```powershell
Get-Process |
    Sort-Object -Property WorkingSet64 -Descending |
    Select-Object -First 3
```

One pipeline over three lines. Each line ends with a pipe except the last. The indentation
shows that the lines belong together.
