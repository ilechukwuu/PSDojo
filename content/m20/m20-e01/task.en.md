# Task

The monitoring writes lines such as the one in the first line of your exercise file. Your
script picks the facts out of it. Leave the line with `param` as it is, the dojo passes
different log lines through it.

1. Store in `$IsError` whether `$LogLine` contains the word `ERROR`.
2. Match the server name, which follows the word `on` and looks like `FS-` plus digits, and
   store it in `$Server`.
3. Match the number in front of the word `percent` and store it as a whole number in
   `$Percent`.

When a part is not found, its variable keeps the value `$null`.
