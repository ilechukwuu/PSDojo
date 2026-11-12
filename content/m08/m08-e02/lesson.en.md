# How comparisons decide

Every comparison returns `$true` or `$false`. Four rules explain most surprises.

**Case.** `-eq` and the other operators ignore upper and lower case. A `c` in front makes
them case-sensitive: `-ceq`, `-clike`.

**The left side decides the type.** If the left value is a number, the right one is
converted to a number. If the left value is text, both are compared as text, character by
character. As text `'10'` comes before `'9'`, because 1 comes before 9.

**Wildcards need -like.** `*` stands for any characters, `?` for exactly one. With `-eq` a
star is just a star.

**Lists.** `-contains` asks whether a list on the left contains a value. `-in` asks the
same the other way round, value on the left.

`-match` compares against a regular expression. Module 20 covers that.

## Example

```powershell
'FS-02' -eq 'fs-02'
'FS-02' -ceq 'fs-02'
10 -gt 9
'10' -gt '9'
'FS-02' -like 'FS-*'
'FS-02', 'FS-03' -contains 'FS-03'
```

The results are True, False, True, False, True, True.
