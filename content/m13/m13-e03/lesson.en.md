# More operators

Five operators that have nothing to do with arithmetic and are used all the time.

- `-split` cuts a text into a list at a separator. `'C:,D:,E:' -split ','` gives three
  texts.
- `-join` is the opposite. It glues a list together with a separator in between.
- `..` is the range operator. `1..5` is the list 1, 2, 3, 4, 5.
- `-is` asks whether a value has a certain type and answers with true or false.
- `-as` tries to convert a value to a type. Unlike a cast it does not fail when that is
  impossible. It returns `$null`, which you can test for.

`-as` is the tool for data you do not trust. A cast stops the script at the first bad
value. `-as` lets you decide what to do with it.

## Example

```powershell
$Drives = 'C:,D:,E:' -split ','
$Drives -join ' | '
1..3
'42' -is [int]
'42' -as [int]
'n/a' -as [int]
```

Line 2 gives `C: | D: | E:`. Line 4 is False, because the value is still text. Line 5 gives
the number 42 and line 6 gives `$null`.
