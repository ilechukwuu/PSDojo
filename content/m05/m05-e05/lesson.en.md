# Pipeline or variables

You can write the same work in two styles. One stores every intermediate result in a
variable and feeds it to the next line. The other connects the commands directly.

Variables named `$a`, `$tmp` or `$x2` that exist only to carry a result one line further
add nothing. They make the reader keep track of names that mean nothing, and each one keeps
all its objects in memory until the script ends. A pipeline says the same in one sentence.

Keep a variable when it earns its name:

- You need the result more than once.
- The name explains something the code does not, such as `$StaleAccounts`.
- You want to look at an intermediate result while debugging.

When the pipeline gets longer than the screen is wide, break it after a pipe character and
indent the following lines by four spaces.

## Example

```powershell
$a = Get-Process
$b = $a | Sort-Object -Property WorkingSet64 -Descending
$Top = $b | Select-Object -First 3

$Top = Get-Process |
    Sort-Object -Property WorkingSet64 -Descending |
    Select-Object -First 3
```

Both versions return the same three processes. The second has nothing to keep track of.
