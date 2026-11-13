# Passing script blocks

Many cmdlets have parameters of the type script block. `Where-Object -FilterScript`,
`ForEach-Object -Process` and `Sort-Object -Property` are the ones you already use. The
cmdlet decides when the block runs and sets `$_` to the current object each time.

Because a block is a value, it does not have to be written at the place where it is used.
Store it in a variable and pass the variable:

`$Volumes | Where-Object -FilterScript $IsLow`

Now the same rule can filter three different lists, and a change of the rule happens in
one place.

One mistake is common. `Where-Object { $IsLow }` wraps the variable in a new block. That
new block only outputs the stored block, and an object counts as true. The filter lets
everything through. Pass the variable itself, without braces around it.

Blocks for these cmdlets use `$_`, not `param`.

## Example

```powershell
$IsStopped = { $_.Status -eq 'Stopped' }
$ToName = { $_.Name.ToUpper() }

$Services | Where-Object -FilterScript $IsStopped | ForEach-Object -Process $ToName
```
