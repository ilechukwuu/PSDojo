# Typical mistakes

**The missing call operator.** A variable followed by a value is not a command.
`$GetStatus $Volume` is a syntax error, and `$GetStatus` alone just outputs the code as
text. Running a block always needs `&` in front.

**`$_` in the wrong place.** `$_` is set by the pipeline: by `Where-Object`,
`ForEach-Object` and similar cmdlets. A block that you invoke yourself with `& $Block
$Value` has no current pipeline object. There `$_` is empty, every property read on it is
empty too, and a comparison with a number is quietly true or false for all inputs. Such a
block needs `param`.

**Parentheses instead of braces.** `Where-Object ($_.Size -gt 10)` computes the comparison
once, immediately, and hands the result to the cmdlet. `Where-Object` expects code, so
this ends in an error about a value that cannot be converted to a script block. A filter
stands in braces.

The rule of thumb: braces mean "later", parentheses mean "now".

## Example

```powershell
$GetSizeClass = {
    param($File)
    if ($File.Length -gt 1GB) { 'large' } else { 'normal' }
}

$Classes = foreach ($File in $Files) { & $GetSizeClass $File }
$Large = $Files | Where-Object { $_.Length -gt 1GB }
```
