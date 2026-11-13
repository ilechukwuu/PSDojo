# Task

The morning mail in your exercise file builds one line per server, three times with the
same code. Last week the limit for `LOW` was changed in two of the three lines only.
Rewrite it.

1. Define a function `Format-ServerLine` with the parameters `$Name` (text) and `$FreeGB`
   (whole number). It returns the line in the same format as before, with `LOW` when fewer
   than 50 GB are free and `ok` otherwise.
2. Build `$Lines` from three calls of the function, for the same three servers and values.
3. The format text with `-f` may appear only once in the file.

The function must use only its parameters.
