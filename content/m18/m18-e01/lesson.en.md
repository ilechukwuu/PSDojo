# if, elseif, else

Until now every line of a script ran. With `if` a script decides.

The condition stands in parentheses, the code that depends on it in curly braces. The block
runs only when the condition is true.

- `elseif` adds another condition. It is checked only when everything above it was false.
- `else` has no condition. Its block runs when nothing above matched.

PowerShell goes through the conditions from top to bottom and runs the first block whose
condition is true. Then it leaves the whole construct. So the order matters: put the
narrowest condition first.

Whatever a block produces becomes the result of the `if`, which lets you assign it to a
variable directly.

## Example

```powershell
$FreePercent = 12

if ($FreePercent -lt 10) {
    $State = 'Critical'
}
elseif ($FreePercent -lt 20) {
    $State = 'Warning'
}
else {
    $State = 'OK'
}
```

12 is not below 10, so the first block is skipped. It is below 20, so `$State` becomes
Warning and the `else` block is never looked at.
