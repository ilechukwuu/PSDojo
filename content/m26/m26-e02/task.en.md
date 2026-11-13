# Task

The backup team keeps getting plans with a retention of 0 days or a type called "weekly".
The function that describes a backup plan has to reject such input itself.

Define a function `Get-BackupPlan` with `[CmdletBinding()]` and three parameters:

1. `$ComputerName`: mandatory text. Only names of the form `FS-`, `APP-` or `WEB-` followed
   by exactly two digits are allowed.
2. `$Type`: text, default `Full`. Only `Full`, `Differential` and `Log` are allowed.
3. `$RetentionDays`: whole number, default 14. Only values from 1 to 90 are allowed.

The function returns one object with the properties `ComputerName`, `Type` and
`RetentionDays`.
