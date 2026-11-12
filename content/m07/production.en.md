# What goes wrong in production

A cleanup job is meant to remove the computer accounts listed in a CSV file. The file has a
column named Computer:

```powershell
Import-Csv -Path stale.csv | Remove-ADComputer
```

`Remove-ADComputer` looks for a property it knows, finds none and reports an error for
every row. The author "fixes" it by adding the names by hand to a text file and piping
that. Now each line binds by value, including a line that says SRV-DC01 because someone
copied the wrong block.

Before you pipe data into a command that changes something, check which parameter the data
will bind to, name the columns accordingly, and run it once with `-WhatIf`.
