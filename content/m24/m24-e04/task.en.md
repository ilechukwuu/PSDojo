# Task

The script in your exercise file is meant to give every volume a status and to list the
critical ones. It has three mistakes around script blocks. Fix them. Leave the line with
`param` as it is.

When the script works:

- `$Statuses` holds one status per volume, in order: `critical` below 10 percent free,
  `warning` below 20, otherwise `ok`.
- `$Critical` holds the volumes with less than 10 percent free.
