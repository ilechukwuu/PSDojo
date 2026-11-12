# Working with aliases

`Get-Alias` searches in both directions.

- `-Name` starts from the alias and shows the cmdlet behind it. It accepts several names at
  once.
- `-Definition` starts from the cmdlet and shows every alias that points to it.

Each result is an object. Its `Name` is the alias, its `Definition` is the cmdlet.

You can create aliases yourself with `Set-Alias`. Two things to know:

- Your alias lives only in the current session. Close the window and it is gone.
- An alias is a name for a command, nothing more. It cannot carry parameters.

Windows PowerShell 5.1 and PowerShell 7 do not ship the same aliases, and PowerShell 7 on
Linux and macOS has fewer than on Windows. Never assume an alias exists, look it up.

## Example

```powershell
Get-Alias -Name gci, gcm
Get-Alias -Definition Get-ChildItem
Set-Alias -Name events -Value Get-Event
```

The first line resolves two aliases. The second lists every alias for `Get-ChildItem`. The
third creates the alias `events` for this session.
