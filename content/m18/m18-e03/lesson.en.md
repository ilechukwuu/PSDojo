# switch

When one value decides between many possibilities, a chain of `elseif` gets long and
repeats the variable in every line. `switch` is made for this.

The value stands in parentheses. In the braces each case is a value followed by a block.
PowerShell compares the value with every case and runs the blocks that match. `default`
runs when no case matched.

Like `if`, a `switch` returns what its blocks produce, so it can be assigned to a variable.

Two options change how cases are compared:

- `-Wildcard` lets a case contain `*` and `?`.
- `-Regex` treats cases as regular expressions.

Comparison ignores case unless you add `-CaseSensitive`.

One difference to `if`: after a match, `switch` keeps checking the remaining cases. More
than one block can run. `break` in a block stops that.

## Example

```powershell
$Action = switch ($Status) {
    'Running' { 'Nothing to do' }
    'Stopped' { 'Start the service' }
    default   { 'Check by hand' }
}

$Role = switch -Wildcard ($Server) {
    'FS-*'  { 'File server' }
    'PRN-*' { 'Print server' }
    default { 'Other' }
}
```
