# One property from many objects

Often you do not want the objects, only one fact about each of them: the names of all
processes, the sizes of all files.

PowerShell makes that easy. If you read a property on a list and the list itself does not
have that property, PowerShell reads it from every element and gives you the values as a
new list. This is called member enumeration.

So `(Get-Process).Name` is the name of every process. Picking the elements one by one with
`[0]`, `[1]`, `[2]` is unnecessary, and it breaks as soon as the list is longer or shorter
than you assumed.

The new list can go straight into the next command, for example into `Measure-Object -Sum`
to add up numbers.

One trap: a list has a few properties of its own, above all `Count` and `Length`. Those
return the number of elements, not a value from each of them.

## Example

```powershell
$Files = Get-ChildItem -Path D:\Reports
$Files.Name
($Files.Length | Measure-Object -Sum).Sum
$Files.Count
```

Line 2 returns every file name. Line 4 returns how many files there are.
