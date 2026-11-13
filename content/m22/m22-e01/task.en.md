# Task

The nightly report job needs its output folder. On a new server the folder is missing, on
an old one it is there and full of reports. Your script has to cope with both. The dojo
passes the base folder as `$Root`.

1. Build the path of the folder `Reports` below `$Root` with `Join-Path` and store it in
   `$ReportDir`.
2. Store in `$Existed` whether that folder exists at this moment, before you create
   anything.
3. Create the folder if it does not exist. Nothing in an existing folder may be lost.
4. Build the path of the file `status.txt` in `$ReportDir` and store it in `$StatusFile`.
5. Write the text `ready` into that file.

Leave the line with `param` as it is.
