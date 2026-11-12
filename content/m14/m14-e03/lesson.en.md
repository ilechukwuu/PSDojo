# The format operator

When a text needs more than a value dropped in, a number with leading zeros, columns that
line up, a date in a fixed layout, the format operator `-f` is the tool.

On the left stands a template with numbered placeholders in curly braces. On the right
stand the values, separated by commas. `{0}` takes the first value, `{1}` the second.

A placeholder can say how the value is shown:

- `{0:D3}` writes a whole number with at least three digits: 7 becomes 007.
- `{0:yyyy-MM-dd}` writes a date in exactly this layout.
- `{0,8}` reserves eight characters and right-aligns the value. `{0,-8}` left-aligns it.

Formats for decimals and percent, such as `{0:N1}`, use the decimal separator of the
system's language. On a German system that is a comma. Keep that in mind for files that
programs read.

## Example

```powershell
'SRV-{0:D3}' -f 7
'{0:yyyy-MM-dd}' -f (Get-Date)
'{0,-8}{1,6}' -f 'FS-02', 75
```

Line 1 gives SRV-007. Line 3 gives FS-02 padded to eight characters, followed by 75
right-aligned in six.
