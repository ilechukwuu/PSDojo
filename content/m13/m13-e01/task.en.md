# Task

For the archive job on FS-02 you calculate a few values. The first lines of your exercise
file hold the raw numbers. Leave them as they are.

1. Store the sum of `$SizeC` and `$SizeD` in gigabytes in `$TotalGB`. Both are in bytes.
2. Store the free share in percent, as a whole number, in `$FreePercent`: `$FreeBytes`
   divided by the sum of both sizes, times 100, rounded.
3. The archive job moves files in batches of `$BatchSize`. Store how many files are left
   over after the last full batch in `$LeftOver`.
4. `$Processed` starts at 120. Add `$BatchSize` to it with `+=`, then count it up by one
   with `++`.
