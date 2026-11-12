# Task

The backup of FS-02 failed last night. Its log has several hundred lines. You search it
instead of reading it. The dojo passes the path of the log file as `$LogFile`.

1. Store every match for the pattern `ERROR` in `$Errors`.
2. Store the number of these matches in `$ErrorCount`.
3. Store the line number of the first match in `$FirstErrorLine`.
4. Store the text of all matching lines in `$ErrorTexts`.
5. Store every match for the literal text `D:\Backup\full.bak` in `$PathHits`. The text
   contains a dot and backslashes, so do not let it be read as a regular expression.

Leave the line with `param` as it is.
