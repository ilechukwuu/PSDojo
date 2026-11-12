# Binding by value

A pipeline does not have to start with a command. Any value can stand on the left: a text,
a variable, a list separated by commas. A list is taken apart, and each element travels
through the pipe on its own.

If the receiving command has a parameter that accepts that type by value, every element
binds there, and the command does its work once per element.

That turns lists into work orders:

- `'Get-Date', 'Get-Item' | Get-Command` looks up two commands. The texts bind to `-Name`.
- A list of paths piped into `Get-Item` returns one item per path. The texts bind to
  `-Path`.

Whether a command accepts text by value, and on which parameter, is not something to
assume. `Get-Help -Parameter *` shows it. `Get-Process`, for example, does not accept plain
text by value at all.

## Example

```powershell
'Get-Date', 'Get-Item' | Get-Command

$Paths = 'D:\Reports\a.csv', 'D:\Reports\b.csv'
$Paths | Get-Item
```

Line 1 returns two command objects. Line 4 returns two file objects, one for each path in
the variable.
