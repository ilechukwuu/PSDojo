# Hashtables

An array finds its elements by position. A hashtable finds them by name. It stores pairs:
a key and the value that belongs to it.

You write it as `@{ }` with the pairs inside, separated by semicolons or by line breaks.

- **Read** a value with the key in square brackets, `$Limits['D:']`, or with a dot,
  `$Server.Site`. A key that does not exist returns `$null`.
- **Add or change** by assigning: `$Limits['E:'] = 20`. If the key exists its value is
  replaced, otherwise the pair is added.
- **Check** with `ContainsKey('E:')`.
- `Count` is the number of pairs, `Keys` and `Values` are the two sides.

Keys that contain spaces or special characters such as a colon need quotes.

A plain hashtable does not keep the order in which you added the pairs. `[ordered]@{ }`
does.

## Example

```powershell
$Limits = @{ 'C:' = 10; 'D:' = 50 }
$Limits['D:']
$Limits['E:'] = 20
$Limits.ContainsKey('F:')
$Limits.Count
```

The results are 50, then nothing for the assignment, False and 3.
