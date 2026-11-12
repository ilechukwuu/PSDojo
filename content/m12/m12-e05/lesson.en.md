# One place for every value

Scripts collect fixed values: a server name, a threshold, a folder. Typed directly into the
code they are called literals. As long as each occurs once, that is fine.

Trouble starts when the same literal appears five times. The day the threshold changes from
90 to 85, someone has to find all five and will find four. The script then warns at 85 in
one place and at 90 in another, and nobody understands why.

The cure is simple. Put each such value into a variable at the top of the script and use
the variable everywhere below.

- The name explains the value. `$WarnAtPercent` says more than `90`.
- A change happens in exactly one line.
- The top of the script becomes a short list of everything that can be adjusted.

A number that appears in the code without explanation is called a magic number. Reviewers
look for them.

## Example

```powershell
$WarnAtPercent = 90
$Server = 'FS-02'

$Title = "Capacity report for $Server"
$Note = "Warning above $WarnAtPercent percent on $Server"
```

Both values are defined once and used wherever they are needed.
