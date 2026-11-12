# List mistakes

**Treating one result as a list.** A variable holds a single text, and the code asks for
`[0]`. It gets the first letter. Wrap the value in `@( )` where it is assigned and the rest
of the script can rely on a list.

**Add on an array.** `$Servers.Add('FS-05')` fails with the message that the collection was
of a fixed size. An array cannot grow in place. Use `+=`, or a List if a lot is added.

**One position too far.** An array with four elements has the positions 0 to 3.
`$Servers[$Servers.Count]` asks for position 4, which does not exist, and returns nothing
without an error. The last element is `[-1]`.

The third mistake is called off-by-one and is one of the most common in all of
programming. Whenever you calculate a position, check the first and the last element by
hand.

## Example

```powershell
$Names = @('FS-01')
$Names[0]

$Servers = 'FS-01', 'FS-02'
$Servers += 'FS-03'
$Servers[-1]
```

Line 2 returns FS-01, because `$Names` is a real array. Line 6 returns FS-03.
