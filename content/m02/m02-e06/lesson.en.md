# Host, version and edition

The same script can run in very different places: in the ISE, in the VS Code terminal, in a
plain console window or unattended as a scheduled task. The program that hosts PowerShell is
called the host. When a script behaves differently on two machines, the first question is
always where it ran.

PowerShell answers that itself with two automatic variables:

- `$Host.Name` is the name of the host program.
- `$PSVersionTable` holds the version details. Its property `PSVersion` is the version and
  `PSVersion.Major` is the first number of it. Its property `PSEdition` is the edition.

The edition tells the two product lines apart: `Desktop` is Windows PowerShell 5.1, `Core`
is PowerShell 6 and later, including PowerShell 7.

The dot after a variable reads one property of the object. You will use that everywhere
from module 6 on.

## Example

```powershell
$Host.Name
$PSVersionTable.PSVersion
$PSVersionTable.PSVersion.Major
```

In the ISE the first line prints `Windows PowerShell ISE Host`. In the VS Code terminal it
prints `Visual Studio Code Host`.
