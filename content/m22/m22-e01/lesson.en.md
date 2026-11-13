# Paths

Three cmdlets carry almost every script that touches the file system.

**`Join-Path`** puts a folder and a name together and takes care of the separator. It
works the same on Windows and Linux, which a path glued together as text does not.

**`Test-Path`** answers with `$true` or `$false` whether a path exists. With
`-PathType Container` it asks for a folder, with `-PathType Leaf` for a file.

**`New-Item`** creates things. `-ItemType Directory` makes a folder, `-ItemType File` an
empty file. It returns the new item, so assign the result to `$null` when you do not want
it in your output. Creating a folder that already exists is an error. Either test first or
add `-Force`, which leaves an existing folder and its content alone.

To write text into a file, `Set-Content` creates or replaces the file and `Add-Content`
appends to it.

## Example

```powershell
$LogDir = Join-Path -Path 'D:\Nordwind' -ChildPath 'Logs'

if (-not (Test-Path -Path $LogDir)) {
    $null = New-Item -Path $LogDir -ItemType Directory
}

$LogFile = Join-Path -Path $LogDir -ChildPath 'sync.log'
Add-Content -Path $LogFile -Value 'Sync started'
```
