# The pipeline

The pipe character `|` connects two commands. Whatever the command on the left returns
becomes the input of the command on the right. Several commands in a row form a pipeline.

What travels through the pipe are objects, not text. The command on the right receives
every process or file complete with all its properties, so it can sort by a property or
pick one without cutting text apart.

Three cmdlets that only make sense in a pipeline, as a first taste:

- `Sort-Object -Property Name` sorts by a property. `-Descending` reverses the order.
- `Select-Object -First 3` lets only the first three objects through.
- `Measure-Object` counts what arrives. Its result has the property `Count`.

Read a pipeline from left to right, like a sentence: get, then sort, then take the first
three.

## Example

```powershell
Get-Process | Sort-Object -Property WorkingSet64 -Descending | Select-Object -First 3
(Get-Process | Measure-Object).Count
```

Line 1 returns the three processes that use the most memory. Line 2 returns how many
processes are running.
