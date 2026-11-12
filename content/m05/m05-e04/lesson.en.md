# Keeping an intermediate result

Sometimes you need two things from one pipeline: the final result and something from the
middle. Running the first command twice is wasteful, and on a busy server the two runs may
not even return the same data.

`Tee-Object` solves that. Like a T-piece in a water pipe it lets everything flow on and
fills a second container on the side:

- `-Variable Name` stores the objects in a variable. Write the name without the dollar
  sign, because you are naming the variable, not using its value.
- `-FilePath` writes them to a file instead.

The alternative is to split the work: store the first result in a variable, then start a
new pipeline from that variable. A variable can stand at the start of a pipeline just like
a command.

## Example

```powershell
Get-Process | Tee-Object -Variable AllProcesses | Select-Object -First 1

$All = Get-Process
$All | Select-Object -First 1
```

After line 1 the variable `$AllProcesses` holds every process, although only one came out
at the end. Lines 3 and 4 reach the same in two steps.
