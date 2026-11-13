# Task

All Nordwind maintenance scripts share a file `settings.ps1`. It sets the variable `$Site`
and outputs the text `settings loaded`. You show a colleague the difference between calling
and dot-sourcing it. The dojo passes the folder as `$Folder`.

1. Build the path of `settings.ps1` in `$Folder` and store it in `$SettingsFile`.
2. Run the file with the call operator and store its output in `$Output`.
3. Store the value of `$Site` at this moment in `$AfterCall`.
4. Dot-source the file. Discard its output.
5. Store the value of `$Site` at this moment in `$AfterDot`.

Leave the line with `param` as it is.
