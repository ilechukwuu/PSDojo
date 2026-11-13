# Task

The function in your exercise file is meant to return the names of the volumes whose free
space is below a threshold. Called as in the last line, `$Low` is empty. It has three
mistakes. Fix them. Leave the line with `param` at the top as it is.

When the script works:

- `Get-LowVolume -Volumes ... -WarnPercent ...` returns only the names of the volumes below
  the threshold, nothing else.
- `$Low` holds the names of the volumes in `$Volumes` with less than 30 percent free.
