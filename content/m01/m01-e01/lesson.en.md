# Cmdlets do the work

PowerShell commands are called cmdlets, spoken "command-lets". You type the name, press
Enter, PowerShell runs it and shows the result.

A cmdlet does not return text. It returns objects: structured data with properties.
`Get-Process` returns one object per running process, `Get-Date` returns one date object.
Every later module builds on that.

To keep a result, store it in a variable. A variable name starts with `$`.

Careful with quotes. They turn a command into plain text: `'Get-Date'` is just eight
characters and nothing runs.

The dojo grades your work by reading the variables in your exercise file. That is why most
tasks ask you to store a result under a given name.

## Example

```powershell
$Today = Get-Date
$Today
```

The first line runs `Get-Date` and stores the date object in `$Today`. The second line shows
what the variable holds.
