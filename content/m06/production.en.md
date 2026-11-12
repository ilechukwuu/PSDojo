# What goes wrong in production

A disk report takes the free space from the text that the console shows:

```powershell
$Line = Get-Volume -DriveLetter D | Out-String
$Free = $Line.Substring(62, 9)
```

It works until someone runs it on a server with a longer volume label. The columns shift,
`Substring` cuts out the wrong characters, and the report shows 0 GB free on a healthy
disk. Monitoring raises an alarm at three in the morning.

The table on screen is only a picture of the object. Column widths change with the data,
the window and the PowerShell version. Read the property instead: `(Get-Volume -DriveLetter
D).SizeRemaining` is a number and stays one.
