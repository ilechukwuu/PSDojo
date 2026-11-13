# When a function returns the wrong thing

Functions fail quietly more often than loudly. Three causes account for most cases.

**A mistyped variable.** PowerShell does not complain about a variable that was never
set. It is simply empty. `$WarnPrecent` instead of `$WarnPercent` turns a comparison into
one against nothing, which is false for every number. The function returns nothing and
reports no error. `Set-StrictMode -Version Latest` at the top of a script turns the use of
an unset variable into an error. Use it while you develop.

**Polluted output.** A result with numbers in front that nobody put there comes from a
method call whose return value was not discarded. Look for `.Add(` and put `$null =` in
front.

**A call with parentheses.** If the first parameter contains everything and the others
are empty or have their defaults, the call was written like in another language.

To find out what a function really returns, look at the raw result:
`$Result | ForEach-Object { $_.GetType().Name }`.

## Example

```powershell
Set-StrictMode -Version Latest

function Get-LargeFile {
    param($Files, $MinBytes = 1GB)
    foreach ($File in $Files) {
        if ($File.Length -ge $MinBytes) { $File.Name }
    }
}

Get-LargeFile -Files $All -MinBytes 500MB
```
