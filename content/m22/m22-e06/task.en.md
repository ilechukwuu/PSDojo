# Task

Before the Nordwind service starts, a script checks that its configuration files are
there. The version in your exercise file glues paths together and lists the folder for
every single file. Rewrite it.

1. Build the path of the folder `config` below `$Root` with `Join-Path`.
2. Build the path of each required file with `Join-Path` and ask with `Test-Path` whether
   it exists.
3. `$Missing` holds the names of the required files that are missing, as before.
4. No `+` for joining text and no `Get-ChildItem` may remain.

Leave the first two lines as they are.
