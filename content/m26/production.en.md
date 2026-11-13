# What goes wrong in production

A cleanup script for old profiles gets a mandatory parameter `-ComputerName`, which is good
practice. It is registered as a scheduled task, and the person who registers it forgets the
argument:

```powershell
powershell.exe -File D:\Scripts\Remove-OldProfile.ps1
```

At 2 a.m. PowerShell asks for the missing value, as it does for every mandatory parameter.
Nobody sits in front of the invisible window. The task stays in the state "Running" for
eleven days, and because the task is set not to start a second instance, the cleanup never
runs again. The disks of the terminal servers fill up.

Start unattended scripts with `-NonInteractive`. A missing mandatory parameter then becomes
an immediate error with an exit code, which monitoring can see.
