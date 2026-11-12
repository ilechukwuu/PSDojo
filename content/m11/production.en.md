# What goes wrong in production

A helper script returns the name of the newest backup file. The author adds a friendly
progress line so that he can see what happens:

```powershell
Write-Output 'Searching for the newest backup ...'
Write-Output $Newest.FullName
```

Another script stores the result in a variable and passes it to `Restore-SqlDatabase`. The
variable now holds two things: the progress text and the path. The restore fails at night
with a path that starts with the word Searching.

Everything written with `Write-Output`, and every value that is simply left standing on a
line, becomes part of the result. Messages for people go to `Write-Verbose`,
`Write-Warning` or `Write-Host`, never into the output.
