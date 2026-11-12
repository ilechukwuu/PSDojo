# Finding string mistakes

String mistakes almost never raise an error. The script runs and the text is wrong: a
variable name appears literally, a value is missing, a file gets a strange name. You find
them by looking at the result, not at an error message.

A short checklist for a text that comes out wrong:

1. **Which quotes?** If the variable name itself appears in the output, the text is in
   single quotes.
2. **A property?** If something like `@{...}` or a type name appears, followed by a dot and
   a word, a property is missing its `$( )`.
3. **What follows the variable?** If a value is simply missing, look at the character
   after the variable name. An underscore, a letter or a digit has become part of the name.

Print the text on its own with F8 before you use it for anything. A file name or a path
that is built wrong does real damage further down.

## Example

```powershell
$Server = 'FS-02'
'Backup of $Server'
"$Server_full.bak"

"Backup of $Server"
"${Server}_full.bak"
```

Lines 2 and 3 are the mistakes, lines 5 and 6 the repaired versions.
