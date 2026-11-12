# Logic mistakes

Logic mistakes do not raise errors. The script takes the wrong branch and does the wrong
thing with full confidence.

**= in a condition.** `if ($Status = 'Stopped')` assigns the text and then tests it. A
non-empty text is true, so the block always runs, and the variable is overwritten on the
way.

**Conditions in the wrong order.** With `if ($Free -lt 20)` first and
`elseif ($Free -lt 10)` second, the second can never be reached: everything below 10 is
also below 20.

**A switch that matches twice.** `switch` checks every case. With `-Wildcard`, a name such
as FS-02 matches `'FS-*'` and also `'*'`. Both blocks run and the result is a list of two
values instead of one. End a block with `break`, or use `default` for the rest.

Test every branch at least once, with a value that should go into it.

## Example

```powershell
$Role = switch -Wildcard ($Server) {
    'FS-*' { 'File server'; break }
    '*'    { 'Other' }
}
```

Without the `break` a file server would get both texts.
