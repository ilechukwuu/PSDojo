# Truthiness

A condition does not have to be a comparison. Any value can stand in the parentheses, and
PowerShell turns it into true or false by fixed rules.

These count as **false**:

- `$null`
- the number 0
- an empty text `''`
- an empty array `@()`

Everything else counts as **true**: any other number, any non-empty text, any object, any
array with elements.

That allows short checks such as `if ($Result)` for "did the command return anything". It
also sets traps:

- The text `'false'` is true, because it is not empty. So is the text `'0'`.
- An array with the single element 0 follows its element and is false.
- A count of 0 is false. `if ($Stopped.Count)` reads well and works.

`-not` or `!` reverses a value: `if (-not $Result)` means "nothing came back".

## Example

```powershell
if ('false') { 'runs' }
if (0) { 'does not run' }
if (@()) { 'does not run' }
if (-not $null) { 'runs' }
```

Lines 1 and 4 print their text, lines 2 and 3 print nothing.
