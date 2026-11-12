# Arrays

An array is a list of values in a fixed order. You have been using arrays all along: every
command that returns several objects returns an array.

You create one by separating values with commas. `@()` around them is optional but makes
the intent clear, and `@()` alone is an empty array.

Each element has a position, called index, and counting starts at 0.

- `$Servers[0]` is the first element.
- `$Servers[-1]` is the last, `[-2]` the one before it. Negative numbers count from the end.
- `$Servers[1..2]` is a slice: the elements at positions 1 and 2, again as an array.
- `$Servers.Count` is the number of elements.

Asking for a position that does not exist returns `$null` and no error.

## Example

```powershell
$Servers = 'FS-01', 'FS-02', 'FS-03', 'FS-04'
$Servers[0]
$Servers[-1]
$Servers[1..2]
$Servers.Count
```

The results are FS-01, FS-04, the two servers FS-02 and FS-03, and 4.
