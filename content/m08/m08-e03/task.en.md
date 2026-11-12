# Task

The on-call engineer wants three precise lists from APP-01 instead of one long one. The
first line of your exercise file holds the names of the critical services. Leave it as it
is.

1. Store the services that are `Stopped` and have the `StartType` `Automatic` in `$Broken`.
   These should be running.
2. Store the services whose `Name` starts with `Nordwind` in `$Nordwind`.
3. Store the services whose `Name` is in `$CriticalNames` and whose `Status` is not
   `Running` in `$CriticalDown`.
