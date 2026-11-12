# Parameters

Parameters control what a cmdlet does. A parameter starts with a hyphen, its value follows
after a space.

- **Named**: `-Name spoolsv`. You write the name, then the value. Always do this in scripts.
- **Positional**: `Get-Process spoolsv`. Some parameters accept a value without the name
  because of its position. Quick to type, harder to read.
- **Switch**: `-Recurse`. No value, it is either there or not.

Some parameters accept several values, separated by commas: `-Name spoolsv, lsass`.

Text with spaces or special characters belongs in quotes: `-Format 'dd.MM.yyyy HH:mm'`.

You do not have to type parameter names. Type a hyphen and press Tab to step through the
parameters of the cmdlet. That works in the console, in ISE and in VS Code.

## Example

```powershell
Get-Date -Year 2026 -Month 12 -Day 24
Get-Date -Format 'dd.MM.yyyy'
Get-Command -Name Get-Date -Syntax
```

The first line builds a date from three named parameters. Everything you leave out is taken
from the current time. The second line returns the date as text. In the third line `-Syntax`
is a switch: it makes `Get-Command` show how `Get-Date` can be called.
