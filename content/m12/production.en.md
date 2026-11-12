# What goes wrong in production

A capacity script reads the disk sizes of all file servers from a CSV file and adds them
up:

```powershell
$Total = 0
$Total = $Row1.SizeGB + $Row2.SizeGB
```

Everything that comes out of a CSV file is text. `'500' + '250'` is not 750, it is the text
500250. The report says the company owns half a million gigabytes, and nobody notices until
the storage budget is cut.

Values from files, user input and web services are text until you convert them. Convert at
the border, where the data enters the script, with `[int]`, `[double]` or `[datetime]`, and
calculate only with converted values.
