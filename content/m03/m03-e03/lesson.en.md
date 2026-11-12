# More ways to search

In module 1 you searched commands by verb, noun and name. `Get-Command` knows more about a
command than its name, and you can search by that too.

- `-ParameterName Encoding` finds every command that has a parameter of that name. Useful
  when you know what you want to control but not which command offers it.
- `-Module` lists what one module provides. A module is a package of commands. The core
  cmdlets for files, processes and services live in `Microsoft.PowerShell.Management`.
- `-CommandType Cmdlet` limits the result to cmdlets and leaves out aliases, functions and
  programs.

One command object carries all details. Its property `Parameters` is a table of every
parameter, and `Parameters.Keys` are just the names. `ModuleName` tells you which module
the command comes from.

Which modules exist differs between Windows PowerShell 5.1 and PowerShell 7 and between
operating systems.

## Example

```powershell
Get-Command -ParameterName ComputerName -CommandType Cmdlet
Get-Command -Module Microsoft.PowerShell.Management
(Get-Command -Name Get-ChildItem).Parameters.Keys
```

The parentheses run `Get-Command` first. The dot then reads a property of the result.
