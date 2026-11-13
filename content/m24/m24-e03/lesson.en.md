# Late reading

A script block is stored as code, not as a result. Two consequences surprise people.

**Nothing runs at definition.** `$Check = { Test-Connection FS-01 }` does not ping
anything. The variable holds a script block object.

**Outer variables are read at invocation.** A block that uses `$Limit` from outside looks
the value up each time it runs. If `$Limit` has changed between definition and call, the
block sees the new value. In a long script that is an easy way to get a filter that
quietly does something else than at the place where it was written.

Two ways out:

- Pass the value in through `param`. This is the clear way.
- Call `.GetNewClosure()` on the block. The copy it returns carries the variable values of
  that moment with it and no longer looks outside.

A block returns everything it outputs. Two outputs are two results, and the caller
receives a list.

## Example

```powershell
$Limit = 10
$IsLow = { param($Value) $Value -lt $Limit }
$Frozen = $IsLow.GetNewClosure()

$Limit = 50

& $IsLow 30
& $Frozen 30
```

The first call returns `True`, the second `False`.
