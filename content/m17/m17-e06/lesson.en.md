# Why splat

A command with six parameters does not fit on one line. People then scroll sideways,
overlook the last parameter, or break the line with a backtick at the end. The backtick is
fragile: a single space after it and the line break no longer counts.

Splatting solves this cleanly.

- Each parameter stands on its own line and can be read like a list.
- The equals signs line up, so a missing value is obvious.
- A comment can explain a single parameter.
- The same set can be reused for a second call, or extended before the call:
  `$Params['Recurse'] = $true`.
- A change shows up as one changed line in version control.

As a rule of thumb, splat when a command has more than three parameters or does not fit on
the line. Name the hashtable after what it is for, not just `$Params`, when a script has
several.

## Example

```powershell
$LogSearch = @{
    Path        = 'D:\Logs'
    Filter      = '*.log'
    Recurse     = $true
    File        = $true
    ErrorAction = 'Stop'
}
$Logs = Get-ChildItem @LogSearch
```
