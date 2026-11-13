# Copy, move, rename

`Copy-Item`, `Move-Item` and `Rename-Item` take `-Path` and `-Destination` (or `-NewName`).
Three traps are typical, and none of them stops the script with a clear error.

**A folder is copied without its content.** `Copy-Item` on a folder copies the folder
itself. Only with `-Recurse` does everything inside come along.

**The destination does not exist.** `Move-Item -Destination D:\Archive` moves a file *into*
the folder if the folder exists. If it does not, the file is *renamed* to `Archive`. The
first file becomes a file called Archive, and every further one fails. Create the folder
first, with `-Force` so that an existing one is no error.

**The filter matches nothing.** `-Filter '.log'` looks for a file named exactly `.log`.
The pattern needs the star: `'*.log'`. A loop over an empty result does nothing and
reports nothing.

`-Force` on copy and move overwrites existing targets. Use it deliberately.

## Example

```powershell
$null = New-Item -Path D:\Archive\2026 -ItemType Directory -Force

Copy-Item -Path D:\Nordwind\config -Destination D:\Archive\2026\config -Recurse

Get-ChildItem -Path D:\Nordwind\logs -Filter '*.log' |
    Move-Item -Destination D:\Archive\2026
```
