# Loop mistakes

**The list instead of the element.** Inside `foreach ($Server in $Servers)` the block uses
`$Servers`, with an s. Every pass then works with the whole list. One letter, and the
editor cannot warn you, because both variables exist.

**One pass too many.** `for ($i = 0; $i -le $Servers.Count; $i++)` runs once more than
there are elements, because positions start at 0. The extra pass reads an element that does
not exist and gets `$null`. The right condition is `-lt`.

**break where continue was meant.** To skip one element, `continue` goes on with the next.
`break` ends the whole loop, and everything after that element is silently left out.

All three produce plausible-looking output. Count the results: if a loop over four servers
returns five lines or two, something is wrong with the loop itself.

## Example

```powershell
foreach ($Server in $Servers) {
    if ($Server -eq 'FS-02') { continue }
    "Patching $Server"
}
```

FS-02 is skipped and the loop goes on with the next server. With `break` the servers after
FS-02 would never be patched.
