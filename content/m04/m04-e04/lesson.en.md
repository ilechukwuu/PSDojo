# Paths, items and their types

A provider path leads to an item and stops there. What you want to know about the item
comes after it, as a property: `(Get-Item -Path Alias:gci).Definition`. Writing the property
into the path does not work, because the provider then looks for an item with that name.

Two parameters decide what kind of item you mean.

`Test-Path -PathType` checks more than existence:

- `Container` is something that can hold other items, in the file system a folder.
- `Leaf` is something that cannot, in the file system a file.

`New-Item -ItemType` says what to create. In the file system the values are `File` and
`Directory`. There is no type called Folder.

Paths with spaces need quotes. Inside double quotes a variable is replaced by its value, so
`"$Root\reports"` becomes the full path.

Both `\` and `/` work as separators in PowerShell on every platform.

## Example

```powershell
(Get-Item -Path Alias:gci).Definition
Test-Path -Path "$Root\reports" -PathType Container
New-Item -Path "$Root\archive" -ItemType Directory
```

Line 2 is only true when reports exists and is a folder.
