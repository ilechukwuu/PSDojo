# Syntax diagrams

`Get-Help` and `Get-Command -Syntax` describe how a command is called in one compact line.
Once you can read it you rarely need more.

- `-Name <string>`: a parameter and the type of value it takes.
- `[-Force]`: square brackets around the whole thing mean optional. No type after the name
  means it is a switch.
- `[-Name] <string>`: brackets around the name only. The name may be left out, the value is
  then taken by position. The parameter itself is still required.
- `[[-Name] <string>]`: both. Optional and positional.
- `<string[]>`: the empty brackets after the type mean several values are allowed.

A command may show several lines. Each line is one parameter set, a combination of
parameters that belong together. You cannot mix parameters from two lines.

`[<CommonParameters>]` stands for parameters every cmdlet has, such as `-Verbose`.

## Example

```powershell
Stop-Process [-Id] <int[]> [-PassThru] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
Stop-Process -Name <string[]> [-PassThru] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

Two parameter sets: stop by id or stop by name. `-Id` is required but positional, `-Force`
is an optional switch.
