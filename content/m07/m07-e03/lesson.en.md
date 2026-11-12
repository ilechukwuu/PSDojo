# Binding by property name

Data from a CSV file, a database or another command arrives as objects with named
properties. Binding by property name turns each of those objects into one call of the
receiving command: every property whose name matches a parameter fills that parameter.

This is why column names matter. A list with a column `Name` can be piped straight into
commands that have a parameter `-Name`. A column `Server` cannot, although it may hold the
same kind of value.

Two details help:

- Several properties can bind at once. An object with `Name` and `Value` fills both
  parameters of a command that has them.
- A parameter can have aliases, and a property that matches an alias binds too.
  `(Get-Command -Name Get-Process).Parameters.Name.Aliases` shows them.

Properties without a matching parameter are simply ignored.

`[pscustomobject]@{ Name = 'x' }` creates a small object with one property. Module 17
explains the syntax.

## Example

```powershell
$Row = [pscustomobject]@{ Name = 'spoolsv'; Site = 'Kiel' }
$Row | Get-Process
```

The property `Name` fills `-Name`. `Site` matches no parameter and is ignored.
