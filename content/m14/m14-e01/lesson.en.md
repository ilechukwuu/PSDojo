# Two kinds of quotes

PowerShell has two kinds of quotes and they behave differently.

**Single quotes** take every character literally. `'Costs $5'` is exactly that text. Use
them whenever nothing has to be inserted. They are the safe default.

**Double quotes** look for `$` and replace what follows.

- A variable is replaced by its value: `"Server $Name"`.
- For anything more than a plain variable, a property, a method call, a calculation, wrap
  it in `$( )`. PowerShell evaluates what is inside and inserts the result:
  `"Free: $($Disk.FreeGB) GB"`.
- If a letter, digit or underscore follows the variable name directly, PowerShell cannot
  tell where the name ends. Curly braces mark it: `"${Name}_backup"`.

To get a real dollar sign or a double quote inside double quotes, put a backtick in front
of it.

## Example

```powershell
$Name = 'FS-02'
$Disk = [pscustomobject]@{ FreeGB = 75 }

'Server $Name'
"Server $Name"
"Free: $($Disk.FreeGB) GB"
"${Name}_backup.zip"
```

Line 4 prints the dollar sign and the word. Lines 5 to 7 print Server FS-02, Free: 75 GB and
FS-02_backup.zip.
