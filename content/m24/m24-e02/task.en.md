# Task

The morning check looks at the volumes of the file servers and of the application servers.
Both lists have to be filtered by the same rule, and the rule changes from time to time.
The two lists are given.

1. Store a script block in `$IsLow` that is true when the `FreePercent` of the current
   object is below 15.
2. Filter `$FileVolumes` with that block and store the result in `$LowFile`.
3. Filter `$AppVolumes` with the same block and store the result in `$LowApp`.
4. Store a script block in `$ToLabel` that returns server and drive of the current object
   as one text, separated by a space, for example `FS-01 D:`.
5. Send `$LowFile` and `$LowApp` through `ForEach-Object` with that block and store the
   texts in `$Labels`.

Leave the given lines as they are.
