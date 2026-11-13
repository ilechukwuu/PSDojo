# Module 24 in review

This quiz closes the module. It covers what you have used in the exercises before:

- A script block is code as a value. Defining it runs nothing.
- `&` invokes a block, `param` gives it input.
- Cmdlets set `$_` for blocks they run. A block you invoke yourself has no `$_`.
- Pass a block variable directly, without braces around it.
- Outer variables are read at invocation. `GetNewClosure()` freezes them.
- Never build commands as text for `Invoke-Expression`.

You pass with 80 percent. If you fail you can try again as often as you like. The feedback
tells you which questions were wrong, not what the right answer is.

## Example

```powershell
$Answer1 = 'b'
```

Each answer is the letter of one option, in quotes.
