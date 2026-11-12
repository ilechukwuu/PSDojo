# Find commands with Get-Command

Nobody memorizes thousands of cmdlets. You search for them. `Get-Command` lists the commands
that are available on the machine you are working on, and Verb-Noun makes the search easy.

- `-Noun` finds everything that works with one kind of thing.
- `-Verb` finds everything that performs one kind of action.
- `-Name` accepts the wildcard `*`, which stands for any characters.

The result is again a list of objects, one per command. Each has a `Name`, a `Verb` and a
`Noun` property.

Which commands you find depends on the machine: the PowerShell version, the operating system
and the installed modules. A cmdlet that is missing in the list is not installed there.

## Example

```powershell
Get-Command -Noun Service
Get-Command -Verb Stop
Get-Command -Name *-Item
```

The first line lists everything for services, the second everything that stops something.
The third lists every command whose name ends with `-Item`, such as `Copy-Item`.
