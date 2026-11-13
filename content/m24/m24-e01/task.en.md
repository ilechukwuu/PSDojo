# Task

Three of your reports convert sizes from bytes to gigabytes, each in a slightly different
way. You define the conversion once. The sizes of three volumes are given in `$VolumeBytes`.

1. Store a script block in `$ToGB`. It has one parameter `$Bytes` and returns the value
   divided by `1GB`, rounded to one decimal place.
2. Invoke the block for the value `53687091200` and store the result in `$Size`.
3. Invoke the block for every value in `$VolumeBytes` and store the results in `$Sizes`.

Leave the first line as it is.
