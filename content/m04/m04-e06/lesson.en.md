# Drives of your own

`New-PSDrive` creates a drive. It needs three things: a `-Name`, the `-PSProvider` behind it
and a `-Root`, the place where the drive starts. From then on the name followed by a colon
works as the start of a path.

That is useful when a long path is needed again and again. A drive named `Reports` that
points at `\\FS-02\Data\Finance\Reports` turns every path into `Reports:\2026`.

Things to know:

- The drive name is not limited to one letter.
- A PowerShell drive exists only in the current session and only for PowerShell. Explorer
  and other programs do not see it. The switch `-Persist` creates a real mapped network
  drive instead, on Windows only and only with a single letter.
- `Remove-PSDrive` removes the drive. The data behind it is not touched.

## Example

```powershell
New-PSDrive -Name Reports -PSProvider FileSystem -Root '\\FS-02\Data\Finance\Reports'
Get-ChildItem -Path Reports:
Remove-PSDrive -Name Reports
```

Line 2 lists the folder on the share through the new drive.
