# What goes wrong in production

A cleanup script builds the path of a user's temporary folder and empties it:

```powershell
$Target = "D:\Profiles\$User.Name\Temp"
Remove-Item -Path "$Target\*" -Recurse -Force
```

Inside double quotes PowerShell replaces only the variable, not the property behind the
dot. `$User.Name` becomes the whole object as text followed by the literal characters
`.Name`. For one user that text happens to be empty. The path collapses to
`D:\Profiles\\Temp\*`, and on the next server, where the variable is empty altogether, to
something far worse.

A property inside a text needs `$( )` around it. And before a path built from variables
goes into a command that deletes, check that the path exists and is the one you meant.
