# What goes wrong in production

A script waits for a service to come up after a restart before it continues:

```powershell
while ((Get-Service -Name NordwindApi).Status -ne 'Running') {
    Start-Sleep -Seconds 5
}
```

One night the service fails to start because a certificate has expired. Its status stays
Stopped, the condition stays true, and the loop waits forever. The scheduled task never
ends, the next night's run cannot start because the previous one is still active, and
nobody is alerted because nothing failed.

Every loop that waits for something outside the script needs a second way out: a maximum
number of attempts or a deadline, and an error when that limit is reached.
