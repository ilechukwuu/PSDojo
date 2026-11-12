# Loops the PowerShell way

People who learned another language first write loops like this: a counter from 0 to the
length, the element fetched by its position, and each result appended to an array with
`+=`.

It works, and it has three weaknesses.

- The counter is a source of off-by-one mistakes and adds nothing when you only need the
  element.
- `$Servers[$i]` hides what the code is about.
- `+=` builds a new array in every pass. With many elements that becomes slow.

The PowerShell way removes all three:

- `foreach ($Server in $Servers)` gives you the element directly.
- Whatever the block produces is collected by the loop itself. Assign the whole loop to
  the variable.

Keep `for` for the cases where the position itself matters, for example when two lists
are read in parallel.

## Example

```powershell
$Lines = @()
for ($i = 0; $i -lt $Servers.Count; $i++) {
    $Lines += "Checking $($Servers[$i])"
}

$Lines = foreach ($Server in $Servers) {
    "Checking $Server"
}
```

Both give the same array. The second has no counter, no index and no `+=`.
