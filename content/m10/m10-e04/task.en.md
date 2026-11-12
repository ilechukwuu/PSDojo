# Task

Three lines of a report script for APP-01 have a format cmdlet in the wrong place. Fix
them.

- `$Stopped` must hold the six stopped service objects, because a later part of the script
  restarts them.
- `$Names` must hold the names of all twelve services as plain text.
- `$TopTable` is only shown to a person. It must be a formatted table of the two processes
  with the highest `WorkingSet64`, largest first, with the columns `Name` and
  `WorkingSet64`.
