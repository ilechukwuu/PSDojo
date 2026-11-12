# One text instead of many pieces

Building a text from pieces with `+` works, and people coming from other languages do it by
habit. It has three drawbacks.

- It is hard to read. The sentence is chopped up by quotes and plus signs, and missing
  spaces between the pieces are easy to overlook.
- It is fragile. If the first piece is a number, `+` starts calculating and the line fails.
- It is long.

PowerShell offers two better forms.

**Insertion** in double quotes for simple cases: `"Server $Name has $Free GB free"`. The
sentence can be read as a sentence.

**The format operator** when values need formatting or the same value appears several
times: `'{0} has {1} GB free' -f $Name, $Free`.

Choose one of the two and the result is shorter, and it reads the way the output will
look.

## Example

```powershell
$Line = 'Server ' + $Name + ' has ' + $Free + ' GB free'

$Line = "Server $Name has $Free GB free"
$Line = 'Server {0} has {1} GB free' -f $Name, $Free
```

All three give the same text. In lines 3 and 4 you can see it.
