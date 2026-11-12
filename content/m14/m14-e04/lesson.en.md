# Here-strings and text methods

A mail body, a configuration snippet or a SQL statement runs over several lines and often
contains quotes. Building that from pieces with `+` is painful. A here-string holds it as it
is.

It starts with `@"` at the end of a line and ends with `"@` at the very beginning of a
line. Everything between is the text, line breaks and quotes included. Variables and
`$( )` are replaced as in double quotes. With `@'` and `'@` nothing is replaced.

The closing marker must stand in the first column. Indenting it is the classic mistake.

For cleaning up text that arrives from outside, a few methods do most of the work:

- `Trim()` removes spaces and line breaks at both ends.
- `Split('.')` cuts at a character, `[0]` takes the first part.
- `ToUpper()` and `ToLower()` change the case.
- `StartsWith()` and `EndsWith()` test the beginning and the end. They are case-sensitive.

## Example

```powershell
$Server = 'FS-02'
$Body = @"
Hello team,
"$Server" needs attention.
"@

'  fs-02.nordwind.example '.Trim().Split('.')[0].ToUpper()
```

`$Body` is two lines of text. The last line returns FS-02.
