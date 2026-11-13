# Paths are not text

Old scripts build paths with `+` and a backslash, and they find out whether a file is
there by listing the folder and searching the list. Both work on the day they are written.

Gluing breaks quietly. A folder that already ends with a backslash gives two of them. An
empty variable gives a path that starts at the root of the drive. And under PowerShell 7
on Linux a backslash is not a separator at all.

Listing a folder to find one file reads every entry of that folder, for every file you ask
about. In a folder with fifty thousand files that takes minutes.

The cmdlets say what you mean:

- `Join-Path -Path $Dir -ChildPath $Name` builds the path.
- `Test-Path -Path $Path` asks whether it is there, without listing anything.

A `foreach` loop can also return values. Whatever is output inside it is collected when
the whole loop is assigned to a variable. That replaces an empty list with `+=`.

## Example

```powershell
$Missing = foreach ($Name in $Required) {
    $Path = Join-Path -Path $ConfigDir -ChildPath $Name
    if (-not (Test-Path -Path $Path)) {
        $Name
    }
}
```
