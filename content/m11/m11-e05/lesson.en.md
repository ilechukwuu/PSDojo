# Quiet by default

Scripts grow chatty while they are written. Every step gets a `Write-Host` line so that the
author can follow along. In production that chatter is a problem.

- A scheduled task has no screen. The lines go nowhere, or they fill a log with noise that
  hides the one line that matters.
- When the script runs against two hundred servers, nobody reads eight hundred status
  lines.
- A colleague who calls the script from his own cannot switch them off.

The convention among tool authors is simple: a tool says nothing unless something is wrong
or the caller asks. Progress notes become `Write-Verbose`, things that need attention
become `Write-Warning`, and the result is the only thing that comes out by default.

Keep `Write-Host` for scripts that are meant to be watched by a person, such as an
interactive setup.

## Example

```powershell
Write-Host 'Connecting to APP-01'
Write-Host 'Reading services'

Write-Verbose -Message 'Connecting to APP-01'
Write-Verbose -Message 'Reading services'
```

The first two lines always print. The last two print only when someone wants to see them.
