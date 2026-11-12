# Task

For a runbook you have to explain how two cmdlets are called. Here is their syntax. Do not
run anything, answer from the diagrams.

```powershell
Restart-Service [-Name] <string[]> [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
Get-EventLog [-LogName] <string> [-Newest <int>] [-After <datetime>] [-EntryType <string[]>] [<CommonParameters>]
```

1. Which parameter of `Restart-Service` must always get a value? Store its name without the
   hyphen as text in `$RequiredParameter`.
2. How many of the parameters shown for `Restart-Service` are switches? Store the number in
   `$SwitchCount`. Do not count the common parameters.
3. Which parameter of `Get-EventLog` accepts several values? Store its name in
   `$ListParameter`.
4. Is this call valid: `Get-EventLog System -Newest 10`? Store `$true` or `$false` in
   `$CallIsValid`.
