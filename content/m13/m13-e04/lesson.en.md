# Operator mistakes

Three mistakes with operators turn up in almost every first script.

**Missing parentheses.** An average written as `$A + $B + $C / 3` divides only the last
value. The numbers look plausible, which makes the mistake hard to spot. Put the sum in
parentheses.

**= where -eq was meant.** `$IsFull = $UsedPercent = 100` does not compare anything. It
assigns 100 to `$UsedPercent` and then the same 100 to `$IsFull`. Both variables are
overwritten.

**A number on the left of a text.** `$FreeGB + ' GB free'` fails, because the left value is
a number and PowerShell tries to turn the text into one. Start with the text, or better,
put the variable into a double-quoted text.

When a calculation gives a wrong value, split it into steps and look at each intermediate
result.

## Example

```powershell
$Average = (120 + 35 + 25) / 3
$IsFull = $UsedPercent -eq 100
$Label = "$FreeGB GB free"
```

The three lines show the right form for each of the three mistakes.
