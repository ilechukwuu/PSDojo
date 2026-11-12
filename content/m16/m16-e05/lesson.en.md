# Code that does not count

Code that names positions one by one, `$Servers[0] + ', ' + $Servers[1] + ', ' +
$Servers[2]`, contains an assumption: there are exactly three elements. The day a fourth
server joins, it is silently left out. The day one is removed, the line produces a trailing
comma and an empty value.

Good list code never assumes a length.

- `-join` connects all elements with a separator, whether there are two or two hundred.
- A slice takes a part by position: `[0..1]` the first two, `[-2..-1]` the last two.
- `Select-Object -First 2` and `-Last 2` do the same in a pipeline and do not complain when
  fewer elements exist.
- `Count` tells you the length when you really need it.

A simple test for your own scripts: would the line still be right with one element, and
with a hundred?

## Example

```powershell
$Servers = 'FS-01', 'FS-02', 'FS-03', 'FS-04'

$Line = $Servers -join ', '
$FirstTwo = $Servers[0..1]
$LastTwo = $Servers[-2..-1]
```

None of the three lines has to change when the list grows.
