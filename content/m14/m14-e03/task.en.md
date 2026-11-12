# Task

New servers get numbered names, and the weekly report needs neat lines. The first lines of
your exercise file hold the data. Leave them as they are.

Use the format operator `-f` in every line.

1. Store the server name `APP-012` in `$ServerName`: the text `APP-`, then `$Number` with
   three digits.
2. Store the date in `$Start` as text in the layout `yyyy-MM-dd` in `$Stamp`.
3. Store the file name `report_APP-012_2026-03-14.csv` in `$FileName`, built from
   `$ServerName` and `$Stamp` with two placeholders.
4. Store a report line in `$Row`: `$ServerName` left-aligned in 10 characters, directly
   followed by `$FreeGB` right-aligned in 6 characters.
