# How replacement really works

When PowerShell meets a `$` inside double quotes it reads on as long as the characters can
belong to a variable name: letters, digits and the underscore. Whatever it has then is
looked up.

Three consequences:

- A dot ends the name. `"$Disk.FreeGB"` replaces `$Disk` and leaves `.FreeGB` standing as
  plain text. A custom object as text looks like `@{FreeGB=75}`.
- An underscore does not end the name. `"$Server_backup"` looks for a variable called
  `Server_backup`.
- A variable that does not exist is replaced by nothing, without an error.

A colon is special too: `"$Drive: full"` is read as a drive-qualified name such as
`$env:PATH`. Write `"${Drive}: full"`.

When a text comes out wrong, look for exactly these places: a dot, an underscore or a colon
directly after a variable.

## Example

```powershell
$Server = 'FS-02'
"$Server.nordwind.example"
"$Server_old"
"$($Server.Length) characters"
```

Line 2 gives FS-02.nordwind.example, which here is what was wanted. Line 3 gives an empty
text. Line 4 gives 5 characters.
