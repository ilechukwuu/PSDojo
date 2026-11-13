# The result of a function

Three rules differ from most other languages.

**Everything that is output is returned.** Not only the last line. Any statement whose
value is not assigned or discarded lands in the result. The classic case is a method that
returns something you did not ask for: `$List.Add('x')` on an `ArrayList` returns the
index of the new entry. Three such calls put 0, 1 and 2 into your result. Discard
unwanted values with `$null = ...`.

**`return` only ends the function.** `return $Value` outputs the value and leaves. It
does not replace what was output before. A bare `return` is useful to leave early.

**Calls use spaces.** `Get-Thing(1, 2)` does not pass two arguments. The parentheses and
the comma build one array, and that array goes to the first parameter. The second stays
empty. Write `Get-Thing 1 2`, or better, `Get-Thing -First 1 -Second 2`.

## Example

```powershell
function Get-ServerList {
    $List = New-Object -TypeName System.Collections.ArrayList
    $null = $List.Add('FS-01')
    $null = $List.Add('FS-02')
    $List
}

$Servers = Get-ServerList
```

Without the two `$null =` the result would have four entries.
