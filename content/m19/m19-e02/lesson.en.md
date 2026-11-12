# ForEach-Object

The `foreach` statement needs the whole list in a variable. In a pipeline, where objects
arrive one by one, the cmdlet `ForEach-Object` does the same job.

Its block runs once for each object that arrives. Inside the block `$_` is the current
object, as in `Where-Object`. Whatever the block produces goes on down the pipeline.

Which of the two to use:

- **`foreach` statement**: the list is already in a variable, or the block is long. It is
  the faster one and reads well.
- **`ForEach-Object`**: you are in the middle of a pipeline, or the source produces so many
  objects that you do not want them all in memory at once.

Do not confuse the two. `foreach` at the start of a statement is the statement. After a
pipe character it is an alias for the cmdlet, and there the `in` syntax does not work.

## Example

```powershell
Get-Service -Name Nordwind* | ForEach-Object { $_.Name.ToUpper() }

Get-ChildItem -Path D:\Logs -Filter *.log |
    ForEach-Object { "$($_.Name): $([math]::Round($_.Length / 1KB)) KB" }
```

Line 1 returns the names in upper case. Lines 3 and 4 return one text per file.
