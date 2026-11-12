# What goes wrong in production

A maintenance script should stop a service only when it is running:

```powershell
if ($Service.Status = 'Running') { Stop-Service -Name $Service.Name }
```

A single equals sign assigns. On the test data the property could be written, the
assignment returned the text Running, and a non-empty text counts as true. The block ran
for every service on the list, also for those that were stopped on purpose and now got a
confusing error, and the script's own data said Running for all of them afterwards.

In a condition always use `-eq`. And when a condition is true for everything or false for
everything, suspect the operator first.
