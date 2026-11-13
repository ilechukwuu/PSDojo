# Module 23 in review

This quiz closes the module. It covers what you have used in the exercises before:

- `param` is the first statement. Type and default per parameter, `[switch]` for flags.
- Functions and scripts read outward and write into their own scope.
- `& $Path` runs in a new scope, `. $Path` in the current one.
- The first execution policy scope that is not `Undefined` applies.
- The execution policy is no security boundary.
- A script depends only on its parameters, never on session leftovers.

You pass with 80 percent. If you fail you can try again as often as you like. The feedback
tells you which questions were wrong, not what the right answer is.

## Example

```powershell
$Answer1 = 'b'
```

Each answer is the letter of one option, in quotes.
