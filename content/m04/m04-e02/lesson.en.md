# One set of cmdlets for every drive

Whatever lives on a drive is called an item: a file, a folder, an environment variable, an
alias. The item cmdlets work the same on every drive.

- `Get-ChildItem` lists what is inside a location.
- `Get-Item` returns one item.
- `Test-Path` answers with `$true` or `$false` whether an item exists.
- `New-Item` creates one, `Remove-Item` deletes one.

A path starts with the drive name and a colon, for example `Env:COMPUTERNAME`.

Environment variables are settings that the operating system hands to every program.
Deployment tools often use them to tell a script where it is running. On the `Env:` drive
each variable is an item with a `Name` and a `Value`.

A variable you create there exists only in your current session. Environment variable names
are case-sensitive on Linux and macOS, on Windows they are not.

## Example

```powershell
Get-ChildItem -Path Env:
Get-Item -Path Env:COMPUTERNAME
(Get-Item -Path Env:COMPUTERNAME).Value
Test-Path -Path Env:DOJO_SITE
New-Item -Path Env:DOJO_SITE -Value 'Kiel'
```

Line 3 reads only the value. Line 4 checks before line 5 creates.
