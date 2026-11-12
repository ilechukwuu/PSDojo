# Loops that wait

Scripts often have to try something until it works: wait for a service, repeat a request
that timed out. A `do` loop fits, because the first attempt always has to happen.

The danger is a loop that never ends. Whenever the thing you wait for is outside your
control, the loop needs two ways out, joined with `-or`:

- the goal is reached, or
- the attempts are used up.

After the loop you check which of the two it was. That check is as important as the loop
itself: a script that carries on after ten failed attempts as if nothing had happened is
worse than one that hangs.

Between real attempts you would pause with `Start-Sleep -Seconds 5`.

## Example

```powershell
$Attempt = 0
$MaxAttempts = 5

do {
    $Attempt++
    $Status = (Get-Service -Name NordwindApi).Status
} until ($Status -eq 'Running' -or $Attempt -ge $MaxAttempts)

$Succeeded = $Status -eq 'Running'
```

The loop ends after at most five passes, whatever the service does.
