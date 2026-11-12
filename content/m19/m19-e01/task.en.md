# Task

The capacity tool delivers one object per volume with the properties `Server`, `SizeGB` and
`FreeGB`. For the weekly report you turn each of them into a report row. The first lines of
your exercise file hold the data. Leave them as they are.

Store one object per volume in `$Report`. Use a `foreach` statement and assign its result.
Each object has these properties, in this order:

1. `Server`: the server name, unchanged.
2. `FreePercent`: `FreeGB` divided by `SizeGB`, times 100, rounded to a whole number.
3. `State`: `Low` when `FreePercent` is below 20, otherwise `OK`.
