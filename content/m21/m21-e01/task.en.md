# Task

The capacity tool exports a CSV file with the columns `Server`, `Drive` and `FreeGB`,
separated by semicolons. You pick the volumes that are running low and hand them on as a
new file. The dojo passes the folder as `$Folder`. The input file is `disks.csv` in it.

1. Read `disks.csv` and store the rows in `$Rows`.
2. Store the rows whose `FreeGB` is below 20 in `$Low`. Compare as a number.
3. Write `$Low` to the file `low.csv` in `$Folder`, separated by semicolons, without the
   type line, encoded as UTF-8.

Leave the line with `param` as it is.
