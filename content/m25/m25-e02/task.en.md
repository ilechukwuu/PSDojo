# Task

The capacity report, the alert mail and the dashboard export all need to know whether a
volume is low. You write the function that all three can use.

1. Define a function `Get-VolumeStatus` with the parameters `$Name` (text), `$FreePercent`
   (`[double]`) and `$WarnPercent` (`[int]`, default 20).
2. It returns one object with the properties `Name`, `FreePercent` and `Status`, in this
   order. `Status` is the text `low` when the free percentage is below the warning value,
   otherwise `ok`.
3. Call the function for the volume `E:` with 35 percent free and store the result in
   `$Status`.
