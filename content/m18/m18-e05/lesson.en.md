# When to prefer switch

A chain of `elseif` that compares the same variable with one fixed value after another is a
table in disguise: this value gives that result. Written as a chain, the variable and the
operator are repeated in every line, and the actual content, the pairs, is hard to see.

`switch` shows the table as a table.

- The variable is named once.
- Each line is one case and its result.
- A new case is one new line.
- `default` makes it obvious what happens to everything else. In an `if` chain a missing
  `else` is easy to overlook.

Keep `if` when the conditions are of different kinds: one compares a number, the next
checks a text, a third calls a command. A `switch` is for one value against many cases.

## Example

```powershell
if ($Code -eq 0) { $Text = 'OK' }
elseif ($Code -eq 1) { $Text = 'Warning' }
elseif ($Code -eq 2) { $Text = 'Error' }
else { $Text = 'Unknown' }

$Text = switch ($Code) {
    0       { 'OK' }
    1       { 'Warning' }
    2       { 'Error' }
    default { 'Unknown' }
}
```
