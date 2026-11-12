# Parentheses or not

Properties and methods look alike, and mixing them up gives three typical mistakes.

**A method without parentheses.** `$Server.ToUpper` does not fail. It returns a description
of the method, a few lines about overloads. Stored in a variable and used later, this
produces very strange output.

**A property with parentheses.** `$Server.Length()` fails with the message that the type
does not contain a method named Length.

**An argument without parentheses.** `$Start.AddDays 7` is a syntax error. Arguments of a
method always go inside the parentheses, unlike the parameters of a cmdlet.

If you are not sure which is which, ask `Get-Member`. The column MemberType says Property
or Method, and for a method the column Definition shows which arguments it expects.

## Example

```powershell
$Server = 'fs-02'
$Server.ToUpper
$Server.ToUpper()
$Server.Length
```

Line 2 prints a table about the method. Line 3 calls it and returns FS-02. Line 4 reads a
property and needs no parentheses.
