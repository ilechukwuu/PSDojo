# What goes wrong in production

A nightly job is supposed to save the list of locked accounts as a CSV file for the service
desk:

```powershell
Search-ADAccount -LockedOut | Format-Table -Property Name, LockedOut | Export-Csv -Path locked.csv
```

In the morning the file is full of columns named ClassId2e4f51ef21dd47e99d3c952918aff9cd
and pageHeaderEntry. `Format-Table` had already turned the accounts into layout
instructions for the screen, and `Export-Csv` faithfully exported those.

`Format-` cmdlets are for human eyes only. They belong at the very end of a pipeline, and
nothing that needs data may come after them. For files that a program reads, select
properties with `Select-Object` and never format at all.
