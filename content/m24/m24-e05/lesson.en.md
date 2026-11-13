# A table of actions

A script that does different things depending on a name usually starts as an `if` chain
or a `switch`. Every new case adds another branch in the middle of the logic.

Script blocks allow a different shape. Put one block per name into a hashtable. The
script then has two separate parts:

- **the table**, which says what exists and what each entry does
- **one line** that looks up the block by name and runs it

`& $Checks[$CheckName] $Value`

Adding a case means adding one line to the table. The line that runs it never changes.
And the table is data: `$Checks.Keys` lists all available names, for a help text or for
validating input.

A name that is not in the table returns `$null`, and invoking `$null` is an error. Test
with `$Checks.ContainsKey($CheckName)` when the name comes from outside.

## Example

```powershell
$Actions = @{
    Upper = { param($Text) $Text.ToUpper() }
    Lower = { param($Text) $Text.ToLower() }
    Trim  = { param($Text) $Text.Trim() }
}

& $Actions['Upper'] 'fs-01'
```
