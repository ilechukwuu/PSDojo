# What goes wrong in production

A monitoring script is supposed to raise an alarm when a disk is more than 90 percent full.
The author comes from another language:

```powershell
if ($UsedPercent > 90) { Send-Alarm }
```

In PowerShell `>` is not "greater than". It redirects output into a file. The script
creates a file named 90 in the current folder on every run, the condition is always true,
and the on-call phone rings every five minutes for every disk in the company.

Comparison operators in PowerShell start with a hyphen: `-gt`, `-lt`, `-eq`. When a
condition behaves strangely, check the operators before anything else.
