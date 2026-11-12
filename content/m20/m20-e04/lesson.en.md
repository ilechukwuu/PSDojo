# Select-String

`-match` tests one text. `Select-String` searches whole files, or many files at once, for a
pattern and returns one object for every line that matches.

Each of these objects tells you where the match is:

- `Line`: the text of the line.
- `LineNumber`: its number in the file.
- `Filename` and `Path`: the file it came from.

Useful parameters:

- `-Path` accepts wildcards, so `D:\Logs\*.log` searches every log file.
- `-Pattern` is a regular expression. Several patterns can be given, separated by commas.
- `-SimpleMatch` treats the pattern as plain text. Use it when you search for something
  that contains dots or brackets and do not want to escape them.
- `-NotMatch` returns the lines that do not match.
- `-Context 2` adds the lines around each match to the output.

It is the PowerShell answer to grep and findstr, with the difference that the result is
objects.

## Example

```powershell
$Hits = Select-String -Path D:\Logs\*.log -Pattern 'ERROR'
$Hits.Count
$Hits[0].LineNumber
$Hits.Line
```

Line 2 is the number of matching lines, line 4 their text.
