# Deleting safely

`Remove-Item` deletes for good. There is no recycle bin and no undo. So a cleanup script is
built in two separate steps:

1. **Collect** the files to delete in a variable. Now you can count them, look at them and
   write them to a log.
2. **Delete** exactly that list.

Every cmdlet that changes something has the switch `-WhatIf`. With it the cmdlet only
prints what it would do. Nothing is changed.

A script can offer the same switch itself. Declare `[switch]$WhatIf` in `param` and hand
the value on with a colon: `-WhatIf:$WhatIf`. Called with `-WhatIf` the script does a dry
run, called without it deletes. The colon is needed because a switch normally takes no
value.

When you pass file objects, use `-LiteralPath $File.FullName`. `-Path` interprets
characters such as `[` and `]` in a name as a pattern.

## Example

```powershell
param($Root = '.', [switch]$WhatIf)

$Limit = (Get-Date).AddDays(-14)
$Dumps = Get-ChildItem -Path $Root -Filter '*.dmp' -File -Recurse |
    Where-Object { $_.LastWriteTime -lt $Limit }

foreach ($Dump in $Dumps) {
    Remove-Item -LiteralPath $Dump.FullName -WhatIf:$WhatIf
}
```
