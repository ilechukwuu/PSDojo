# Pattern mistakes

A pattern that is too loose is the dangerous kind of mistake: it matches what it should,
passes every quick test, and also matches things nobody thought of.

**No anchors.** A validation such as `-match 'FS-\d\d'` accepts every text that contains a
server name somewhere. Validation means the whole text: `'^FS-\d\d$'`.

**An unescaped dot.** `'nordwind.example'` accepts any character between the two words.
Escape it: `'nordwind\.example'`.

**The replacement in double quotes.** `"$2 $1"` is filled in by PowerShell before
`-replace` runs. The groups are never used and the text comes out empty or wrong.

To test a pattern, do not only try the texts it should match. Try at least one that looks
similar and must not match. That second kind of test finds these mistakes.

`[regex]::Escape('web.nordwind.example')` returns the text with every special character
escaped, ready to be used as a literal pattern.

## Example

```powershell
'XFS-021' -match '^FS-\d\d$'
'fs-02.nordwindXexample' -match 'nordwind\.example$'
'Keller, Anna' -replace '^(\w+), (\w+)$', '$2 $1'
```

The results are False, False and Anna Keller.
