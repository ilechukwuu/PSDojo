# -replace and groups

`-replace` takes a pattern and a replacement text. Every part of the input that matches the
pattern is swapped for the replacement. Without a replacement the matches are removed.

The replacement can refer to what the parentheses captured: `$1` is the first group, `$2`
the second. That lets you rearrange a text instead of just deleting or overwriting parts.

Write the replacement in **single quotes**. In double quotes PowerShell would replace `$1`
itself, with the value of a variable named 1 that does not exist, before the regex engine
ever sees it.

Two more building blocks:

- `\s+` is one or more white space characters. Replacing it with one space cleans up
  untidy input.
- `(?<Server>FS-\d+)` gives a group a name. After `-match` you read it as
  `$Matches['Server']` or `$Matches.Server`, which says more than `$Matches[1]`.

## Example

```powershell
'Keller,   Anna' -replace '\s+', ' '
'Keller, Anna' -replace '^(\w+), (\w+)$', '$2 $1'

if ('Disk on FS-02' -match '(?<Server>FS-\d+)') { $Matches.Server }
```

The results are `Keller, Anna`, `Anna Keller` and FS-02.
