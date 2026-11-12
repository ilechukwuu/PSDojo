# Describe the line, do not count words

A common way to take a log line apart is to split it at the spaces and pick words by
position: the third word is the level, the eighth is the server. That works for the line
you tested with. It breaks, without an error, as soon as a line has one word more or less,
and log lines do.

A regular expression with named groups describes what you are looking for instead of where
it happens to stand:

- the date is four digits, a hyphen, two digits, a hyphen, two digits at the start,
- the level is the word after the time,
- the server follows the word `on`,
- the number stands in front of `percent`.

Words in between are covered by `.*`, which means any characters, as many as needed.

Name every group. `$Matches.Server` documents itself, and adding a group later does not
shift the numbers of the others.

## Example

```powershell
$Pattern = '^(?<Date>\d{4}-\d{2}-\d{2}) \S+ (?<Level>\w+) .* on (?<Server>FS-\d+)'

if ($Line -match $Pattern) {
    $Matches.Date
    $Matches.Level
    $Matches.Server
}
```

`\S+` is a run of non-space characters, here the time.
