# How the pipe finds a parameter

When an object arrives through the pipe, the receiving command has to decide which of its
parameters gets it. It never guesses. It follows two rules, and the help shows for every
parameter which of them apply: `Accept pipeline input?`

**ByValue.** The parameter takes the whole object if its type fits. A service object fits a
parameter of the type ServiceController, a text fits a parameter of the type string.

**ByPropertyName.** The parameter takes the value of a property that has the same name as
the parameter. An object with a property `Name` feeds the parameter `-Name`.

PowerShell tries ByValue first. Only if no parameter accepts the object as a whole does it
look at property names.

A parameter that shows `false` takes nothing from the pipe. And a parameter you already set
by hand is no longer available for pipeline input.

## Example

```powershell
Get-Help -Name Stop-Service -Parameter InputObject
Get-Help -Name Stop-Service -Parameter Name

Get-Service -Name Spooler | Stop-Service -WhatIf
```

The service object binds to `-InputObject` by value. `-WhatIf` shows what would happen
without doing it.
