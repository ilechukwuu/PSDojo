# Taking paths apart

**`Split-Path`** is the counterpart of `Join-Path`. `-Parent` returns everything up to the
last separator, `-Leaf` what comes after it. It works on the text only. The path does not
have to exist.

**File objects** from `Get-Item` or `Get-ChildItem` carry the parts ready for use:

- `Name` is the file name with extension.
- `Extension` is the part from the **last** dot on, including the dot.
- `BaseName` is the name without that extension.
- `DirectoryName` is the path of the folder.

A file called `data.tar.gz` therefore has the extension `.gz`.

**`Test-Path -PathType`** asks more exactly. `Container` is true only for a folder, `Leaf`
only for a file. A path that exists but is of the other kind gives `$false`.

**`Join-Path`** tidies up. If the folder ends with a separator or the child starts with
one, the result still has exactly one between them.

## Example

```powershell
Split-Path -Path 'D:\Shares\HR\plan.xlsx' -Parent
Split-Path -Path 'D:\Shares\HR\plan.xlsx' -Leaf

$File = Get-Item -Path 'D:\Shares\HR\plan.xlsx'
$File.BaseName
$File.Extension
```

The results are `D:\Shares\HR`, `plan.xlsx`, `plan` and `.xlsx`.
