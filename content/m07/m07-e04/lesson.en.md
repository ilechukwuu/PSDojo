# When binding fails

The message is long, but it says one thing: "The input object cannot be bound to any
parameters for the command either because the command does not take pipeline input or the
input and its properties do not match any of the parameters that take pipeline input."

It has two causes, and each has its own fix.

**The property has the wrong name.** The data is fine, but the column is called `Process`
and the parameter is called `-Name`. Rename the column where the data is created. Later you
will also learn to rename it on the way with `Select-Object`.

**The value does not belong in the pipe at all.** Not every parameter takes pipeline input.
A format text, a count or a switch has to be written as a parameter. Piping it in either
fails or, worse, binds to a different parameter than you meant.

`Trace-Command -Name ParameterBinding -PSHost -Expression { ... }` shows every step of the
binding when you want to see exactly what PowerShell tried.

## Example

```powershell
'yyyyMMdd' | Get-Date
# Cannot convert value "yyyyMMdd" to type "System.DateTime"

Get-Date -Format 'yyyyMMdd'
```

The text was bound to `-Date` by value. It belongs to `-Format`, which takes no pipeline
input.
