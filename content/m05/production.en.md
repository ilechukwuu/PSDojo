# What goes wrong in production

A script is supposed to restart the three services of a line-of-business application. The
author builds the list in one line and restarts in the next:

```powershell
Get-Service -Name Nordwind*
Restart-Service
```

The first line only prints the services. Nothing connects it to the second line, so
`Restart-Service` has no input and asks for a name. Run unattended, the script hangs there
until someone notices in the morning.

Objects travel from one command to the next only through the pipe character. A new line or
a semicolon starts a separate command that knows nothing about the previous one.
