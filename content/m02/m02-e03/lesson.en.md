# Syntax errors

Some mistakes stop PowerShell from even reading a script: a quote that is never closed, a
parenthesis without its partner. These are syntax errors. Nothing runs until they are fixed,
not even the lines above the mistake.

Your editor finds them while you type:

- Both editors underline the spot with a red squiggle. Hover over it to read the message.
- VS Code also lists every problem in the Problems panel, Ctrl+Shift+M.
- Colors help too. If half the file suddenly has the color of text, a quote is open.
- Put the cursor next to a bracket and the editor highlights its partner.

The squiggle often sits later than the real mistake, because PowerShell only notices the
problem when the rest stops making sense. Look at the marked spot first, then to the left
and above.

## Example

```powershell
$Name = 'FS-02
$Size = (120 + 80
```

Line 1 is missing the closing quote, so line 2 is colored as text. After you close the
quote, line 2 shows its own problem: the closing parenthesis is missing.
