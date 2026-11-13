# Don't repeat yourself

The same three lines, copied and adjusted for each server, are the most common form of
script code. The cost shows when the rule changes: someone edits two of the three copies,
and from then on the report contradicts itself.

Turning copies into a function takes three steps.

1. **Find what differs** between the copies. Those are the parameters.
2. **Put what is the same** into the function body.
3. **Replace each copy** with a call.

One rule keeps the function honest: it uses only its parameters. A function that reads
`$Name` from the surrounding script works as long as the caller happens to set a variable
of that name first. It breaks when the function is moved to another file or called from
somewhere else. If the body needs a value, it comes in through `param`.

A good test: could you copy the function alone into an empty console and call it?

## Example

```powershell
function Format-ShareLine {
    param([string]$Share, [int]$UserCount)

    '{0} has {1} open sessions' -f $Share, $UserCount
}

$Lines = @(
    Format-ShareLine -Share 'HR' -UserCount 12
    Format-ShareLine -Share 'Projects' -UserCount 47
)
```
