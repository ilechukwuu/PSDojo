# Get-Member

What you see on screen is a small selection. A process object has more than fifty
properties, the default table shows a handful. To work with an object you need to know what
it really contains, and `Get-Member` tells you.

Pipe any object into it. The answer has three parts:

- **TypeName** at the top: the kind of object, for example `System.DateTime`.
- **Properties**: the data the object carries, such as `DayOfWeek`.
- **Methods**: the things the object can do, such as `AddDays`.

`-MemberType Property` shows only properties, `-MemberType Method` only methods.

If you pipe a hundred files into `Get-Member` you get one answer, not a hundred. It reports
each type once.

Together with `Get-Help` and `Get-Command` this is the third tool for finding your way: help
explains commands, `Get-Member` explains what they return.

## Example

```powershell
Get-Date | Get-Member
Get-Date | Get-Member -MemberType Property
Get-Date | Get-Member -MemberType Method
```

The first line shows that `Get-Date` returns a `System.DateTime` and lists everything that
type offers.
