# Variables and types

A variable is a named place for a value. The name starts with `$`, the value is assigned
with `=`. Names are not case-sensitive. Choose names that say what is inside: `$FreeGB`
beats `$f`.

Every value has a type, and the type decides what you can do with it. The ones you meet
first:

- `String`: text, written in quotes. `'FS-02'`
- `Int32`: a whole number. `445`
- `Double`: a number with decimals. The decimal separator in code is always a point.
  `81.5`
- `Boolean`: `$true` or `$false`.
- `DateTime`: a point in time, for example from `Get-Date`.

You do not declare a type. A variable takes the type of whatever you put in, and it changes
when you assign something else. `GetType().Name` tells you what is in it right now.

`$null` means nothing at all. A variable that was never assigned is `$null`.

## Example

```powershell
$Server = 'FS-02'
$Port = 445
$Server.GetType().Name
$Port.GetType().Name
```

Lines 3 and 4 return String and Int32.
