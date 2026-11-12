# Task

The capacity report for APP-01 must be readable for people who do not think in bytes.

Store one object per process in `$Report`. Each object has exactly these three properties,
in this order:

1. `Name`, unchanged.
2. `MemoryMB`: `WorkingSet64` divided by `1MB`, rounded to a whole number.
3. `Team`: the value of the property `Category` under the new name.

Then store the same objects sorted by `MemoryMB`, largest first, in `$Sorted`.
