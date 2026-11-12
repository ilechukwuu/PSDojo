# One call for the whole list

When you have several names, the first idea is often to call the command once per name and
collect the results. That works, but it is slow and long, and against a remote server each
call is a separate round trip.

Look at the type in the syntax first. `-Name <string[]>` ends with `[]`, so the parameter
takes the whole list at once. There are two equally good ways to hand it over:

- As a parameter value: `Get-Process -Name $Names`
- Through the pipe, if the parameter takes pipeline input: `$Rows | Get-Process`

Either way the command runs once and returns everything together.

Calling a command separately for each element is only right when the parameter takes a
single value, or when each element needs different treatment. Module 19 covers loops.

## Example

```powershell
$a = Get-Process -Name spoolsv
$b = Get-Process -Name lsass
$All = $a, $b

$Names = 'spoolsv', 'lsass'
$All = Get-Process -Name $Names
```

Lines 1 to 3 ask twice. Line 6 asks once and returns the same two processes.
