# When streams are mixed up

Three mix-ups make scripts unusable for other scripts, and each shows a clear symptom.

**Data written to the host.** `Write-Host $Names` shows the names and returns nothing. The
symptom: the script prints fine by hand, but a variable that captures it is empty.

**A status text in the result.** `Write-Output 'Reading services'` puts that sentence into
the result, in front of the data. The symptom: the first element of the result is a
sentence, and whatever processes the result trips over it.

**The wrong stream number.** `2>` redirects errors. A warning written with `Write-Warning`
is stream 3 and goes past it. The symptom: the log file stays empty and the warning still
appears on screen.

To see what a script really returns, capture it and count:

## Example

```powershell
$Result = .\check.ps1
$Result.Count
$Result | Get-Member
```

If the count is higher than expected or `Get-Member` reports more than one type, something
that is not data has leaked into the result.
