# Task

A colleague reports: "I set the execution policy on PRN-01 to RemoteSigned and my script
still does not run." You write the few lines that show which policy really applies and
where it comes from.

1. Store the result of `Get-ExecutionPolicy -List` in `$Policies`.
2. Find the first entry whose `ExecutionPolicy` is not `Undefined` and store it in
   `$Winner`. The list is already in order of precedence.
3. Store the policy of that entry as text in `$Effective`.
4. Store the scope of that entry as text in `$SetBy`.

The dojo replaces the cmdlet with invented data, so nothing on your machine is read or
changed.
