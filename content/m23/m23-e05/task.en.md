# Task

The script in your exercise file is meant to report which volumes have less free space than
a threshold and how many volumes it looked at. It does not even start. It has three
mistakes. Fix them.

When the script works, it outputs one object:

- `Low` holds the names of the volumes whose `FreePercent` is below `-WarnPercent`.
- `Checked` is the number of volumes that were tested.

The dojo calls the script with invented volumes, once with `-WarnPercent 25` and once
without it.
