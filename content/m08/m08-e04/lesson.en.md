# Filters that go wrong

A filter that is written wrong often gives no error. It returns an empty list or the wrong
objects, and a script that acts on that list does the wrong thing quietly. Three mistakes
are behind most cases.

**= instead of -eq.** `$_.Status = 'Stopped'` does not compare. It tries to write the value
into the property. On real objects that usually fails, on plain data it silently changes
every object, and the filter lets nothing through.

**A wildcard with -eq.** `$_.Name -eq 'Nordwind*'` looks for a service that is literally
called Nordwind followed by a star.

**A property without $_.** Inside the braces `Status -eq 'Running'` makes PowerShell look
for a command named Status.

When a filter returns nothing, test the condition alone on one object you know.

## Example

```powershell
$One = Get-Service -Name Spooler
$One.Status -eq 'Running'
$One.Name -like 'Spo*'
```

Each line prints True or False. If it prints something else or nothing, the condition is
the problem, not the pipeline.
