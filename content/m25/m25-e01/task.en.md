# Task

Half of your team's scripts calculate the free space of a volume in percent, and two of
them round differently. You write the one function everybody will use.

1. Define a function `Get-FreePercent` with the parameters `$FreeGB` and `$SizeGB`, both of
   the type `[double]`, in this order.
2. The function returns the free space in percent of the size, rounded to one decimal
   place.
3. Call the function for 120 GB free of 480 GB and store the result in `$Percent`.
