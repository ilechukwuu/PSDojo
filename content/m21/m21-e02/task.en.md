# Task

The disk monitoring keeps its settings in `monitor.json`. You read values from it and write
a result file. The dojo passes the folder as `$Folder`. The file looks like this:

```powershell
{
  "site": "Hamburg",
  "thresholds": { "warnPercent": 20, "criticalPercent": 10 },
  "servers": [
    { "name": "FS-01", "drives": ["C:", "D:"] },
    { "name": "FS-02", "drives": ["C:", "D:", "E:"] }
  ]
}
```

1. Read the file into `$Config`.
2. Store the warning threshold in `$WarnPercent`.
3. Store the names of all servers in `$ServerNames`.
4. Store the number of drives of the second server in `$DriveCount`.
5. Write `$Config` as JSON to `copy.json` in `$Folder`. Nothing may be lost: use a depth of
   5 and UTF-8.

Leave the line with `param` as it is.
