# What goes wrong in production

A team has a function `Copy-ConfigBackup` with two parameters, `$Source` and `$Target`. A
maintenance script calls it by position:

```powershell
Copy-ConfigBackup $BackupDir $ConfigDir
```

Months later someone reorders the parameters in the function so that the target comes
first, "because that reads better". The call in the maintenance script still runs without
any error. It now copies the three-week-old backup over the live configuration.

Positions are a convenience for typing at the console. In anything that is saved to a file,
write the parameter names: `-Source $ConfigDir -Target $BackupDir`. A call with names
survives a reordering, and a renamed parameter fails loudly instead of doing the wrong
thing.
