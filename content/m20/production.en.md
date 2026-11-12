# What goes wrong in production

A cleanup script removes test accounts. Their names contain the marker `.test`:

```powershell
Get-ADUser -Filter * | Where-Object { $_.SamAccountName -match '.test' } | Remove-ADUser
```

In a regular expression a dot means any character. The pattern matches every name that has
the letters test anywhere after at least one other character: m.testa, but also contest1
and jtester, the account of Mr. Tester from accounting.

`-match` and `-replace` always work with regular expressions. A dot that means a dot has to
be written `\.`, and a pattern that should match a whole name needs `^` at the start and
`$` at the end. `[regex]::Escape()` escapes a text you want taken literally.
