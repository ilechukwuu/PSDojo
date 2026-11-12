# Silent conversion

PowerShell tries hard to make an operation work. If the two sides have different types, it
converts one of them without telling you. The rule is the same as for comparisons: the left
side decides.

- Text on the left: the right side becomes text. `+` joins, `*` repeats.
- A number on the left: the right side becomes a number. If that is impossible you get an
  error.

Three more conversions cause surprises:

- `[int]` rounds, it does not cut off. And it rounds a half to the nearest even number:
  2.5 becomes 2, 3.5 becomes 4.
- Dividing two whole numbers gives a decimal number when it does not come out even.
- As a boolean, every non-empty text counts as true, also the text `'false'`. Only the
  empty text, 0 and `$null` count as false.

## Example

```powershell
'5' + 3
5 + '3'
'ab' * 3
[int]3.7
7 / 2
[bool]'false'
```

The results are 53, 8, ababab, 4, 3.5 and True.
