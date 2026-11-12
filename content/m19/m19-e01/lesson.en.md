# The foreach statement

A loop repeats a block of code. The most common one goes through a list and runs the block
once for every element.

`foreach ($Disk in $Disks) { ... }`

Before each pass PowerShell puts the next element into the variable you named, here
`$Disk`. Inside the block you work with that one element. By convention the list has a
plural name and the loop variable the singular.

Three things to know:

- Everything the block produces is collected. Assign the whole `foreach` to a variable and
  you get an array of the results. That is cleaner and faster than appending with `+=`
  inside the loop.
- If the list is empty, the block does not run at all.
- Changing the loop variable does not change the list.

## Example

```powershell
$Servers = 'FS-01', 'FS-02', 'FS-03'

$Lines = foreach ($Server in $Servers) {
    "Checking $Server"
}
```

The block runs three times. `$Lines` holds three texts.
