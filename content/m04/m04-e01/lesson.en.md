# Providers and drives

In PowerShell a drive is more than a disk. A provider is an adapter that presents some data
store as a drive, so that you can walk through it like through folders. The same cmdlets
then work everywhere.

Providers you will meet:

- `FileSystem`: disks and shares, drives like `C:`.
- `Environment`: environment variables, drive `Env:`.
- `Alias`, `Variable`, `Function`: what the current session knows.
- `Registry`: the Windows registry, drives `HKLM:` and `HKCU:`.
- `Certificate`: the Windows certificate stores, drive `Cert:`.

`Get-PSProvider` lists the providers, `Get-PSDrive` lists the drives. A drive object knows
its `Name`, its `Provider` and its `Root`.

The registry and certificate providers exist only on Windows. On Linux and macOS the file
system has a single drive named `/`.

## Example

```powershell
Get-PSProvider
Get-PSDrive
Get-PSDrive -Name Env
Get-PSDrive -PSProvider FileSystem
```

The last line lists only the drives that are backed by the file system provider.
