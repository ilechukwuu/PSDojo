# Task

A script that restarts print servers behaves differently depending on how many servers a
query returns. You examine the lines in question. Predict what they return. Do not run
anything.

```powershell
$Found = 'PRN-01'
$Many = 'PRN-01', 'PRN-02', 'PRN-03'

$Found[0]
@($Found)[0]
@($Found).Count
$Many[5]
($Many + 'PRN-04').Count
@().Count
```

Store the results of lines 4 to 9 in `$Result1` to `$Result6`. For a result that is
nothing, store `$null`.
