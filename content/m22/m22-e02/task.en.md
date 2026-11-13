# Task

Drive D: of APP-01 is filling up. You want to know how much space the old log files of the
application take, including those in subfolders. The dojo passes the log folder as `$Root`.

1. Store every file with the extension `.log` below `$Root`, in all subfolders, in `$Logs`.
   Files only.
2. Store those of them that were last written more than 30 days ago in `$OldLogs`.
3. Store the total size of `$OldLogs` in bytes in `$TotalBytes`.
4. Store the name of the largest file in `$OldLogs` in `$Largest`.

Leave the line with `param` as it is.
