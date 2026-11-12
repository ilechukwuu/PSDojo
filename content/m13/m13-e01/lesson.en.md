# Arithmetic and assignment

The arithmetic operators are the familiar ones: `+`, `-`, `*`, `/`. One more is useful in
scripts: `%`, called modulo. It returns the remainder of a division. `10 % 3` is 1. That
answers questions like "how many files are left over after full batches".

Sizes can be written with units. `1KB`, `1MB`, `1GB` and `1TB` are numbers: `1GB` is
1073741824. Dividing a size in bytes by `1GB` gives gigabytes.

Assignment has short forms for changing a variable based on its own value:

- `$Count += 5` adds 5 to what is in `$Count`.
- `$Count -= 1` subtracts.
- `$Count++` adds exactly one, `$Count--` subtracts one.

Multiplication and division are done before addition and subtraction. Parentheses change
that order.

## Example

```powershell
$TotalBytes = 536870912000
$TotalGB = $TotalBytes / 1GB

$Files = 47
$LeftOver = $Files % 10

$Checked = 0
$Checked += 5
$Checked++
```

`$TotalGB` is 500, `$LeftOver` is 7 and `$Checked` ends at 6.
