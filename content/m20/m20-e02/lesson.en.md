# What a pattern really matches

Three properties of regular expressions surprise everyone at first.

**A match anywhere counts.** `-match 'FS-\d'` is true for XFS-021-old, because the pattern
occurs somewhere inside. To match a whole text, anchor the pattern: `^` stands for the
start, `$` for the end. `'^FS-\d{2}$'` matches FS-02 and nothing longer.

**Special characters.** Some characters have a meaning: `.` is any character, and `*`,
`+`, `?`, `(`, `)`, `[`, `{`, `^`, `$`, `|` and `\` are special too. To mean the character
itself, put a backslash in front: `\.` is a real dot.

**Case.** `-match` ignores upper and lower case, like all comparisons. `-cmatch` is the
case-sensitive form.

`-replace` uses the same patterns. It replaces every match, not just the first.

## Example

```powershell
'XFS-021' -match 'FS-\d'
'XFS-021' -match '^FS-\d{2}$'
'nordwindXexample' -match 'nordwind.example'
'nordwindXexample' -match 'nordwind\.example'
'10.0.0.1' -replace '.', '-'
```

The results are True, False, True, False and `--------`: the dot matched every character.
