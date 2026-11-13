# Task

The script in your exercise file outputs the names of report files older than a number of
days. Folder and number are typed into it as global variables. Rewrite it.

1. Add a `param` block with `$Path` (text, default `D:\Reports`) and `$Days` (whole number,
   default `30`).
2. Use the parameters instead of the global variables.
3. No `$global:` variable may remain. The limit date is an ordinary variable.

The script still outputs the names of the files in `$Path` that were last written more than
`$Days` days ago.
