# Task

For an audit you have to prove which commands a cleanup script uses and that its two input
files exist. The first lines of your exercise file hold the lists. Leave them as they are.

1. Pipe `$CommandNames` into `Get-Command` and store the result in `$Commands`.
2. Pipe `$Paths` into `Get-Item` and store the result in `$Files`.
3. Pipe the single text `'gci'` into `Get-Alias` and store the result in `$Alias`.

Do not write any parameter name after the pipe. The binding does the work.
