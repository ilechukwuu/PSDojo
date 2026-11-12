# -match and $Matches

A regular expression, regex for short, is a pattern that describes text. `-match` tests
whether a text contains something that fits the pattern, and answers with true or false.

The building blocks you need first:

- Ordinary characters stand for themselves: `ERROR` matches the word ERROR.
- `\d` is any digit, `\w` a letter, digit or underscore, `\s` white space.
- `+` after something means one or more of it. `\d+` is a whole number.
- `{2}` means exactly two. `\d{2}` is two digits.
- Parentheses capture the part they enclose.

After a successful match the automatic variable `$Matches` holds what was found:
`$Matches[0]` is the whole match, `$Matches[1]` the first captured part, `$Matches[2]` the
second.

`$Matches` is only refreshed when a match succeeds. Always check the result of `-match`
before you read it.

## Example

```powershell
$Line = 'Disk D: on FS-02 is 91 percent full'

if ($Line -match 'on (FS-\d+) is (\d+) percent') {
    $Server = $Matches[1]
    $Percent = [int]$Matches[2]
}
```

`$Server` is FS-02 and `$Percent` is the number 91.
