# Precedence

When an expression has several operators, PowerShell does not simply go from left to right.
It follows a fixed order.

1. Parentheses first.
2. `-not` and `!`.
3. `*`, `/` and `%`.
4. `+` and `-`.
5. Comparisons such as `-eq`, `-gt`, `-like`.
6. `-and` and `-or`. These two have the same rank and are read from left to right.

So arithmetic is finished before anything is compared, and all comparisons are finished
before they are combined.

Rank 6 is the trap. `A -or B -and C` is read as `(A -or B) -and C`, which is rarely what the
author meant.

Nobody should have to remember this table to read your script. Use parentheses wherever
two different kinds of operators meet. They cost nothing and remove every doubt.

## Example

```powershell
2 + 3 * 4
(2 + 3) * 4
10 - 4 -gt 5
$true -or $false -and $false
```

The results are 14, 20, True and False. In line 4 the `-or` is done first, then the `-and`
with `$false`.
