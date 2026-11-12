# Growing lists

An array has a fixed size. It has no working `Add` method, and nothing can be removed.

`+=` seems to add an element anyway. What it really does is build a new array, one element
longer, copy everything over and throw the old one away. For ten servers nobody notices.
For fifty thousand log lines the script spends its time copying.

When a list has to grow or shrink, use a generic List. You say what it holds when you
create it:

`$Queue = [System.Collections.Generic.List[string]]::new()`

- `Add('x')` appends an element.
- `Remove('x')` removes the first element with that value.
- `Contains('x')` answers true or false. It is case-sensitive.
- `Count` and `[0]` work as with an array.

A List goes into a pipeline like an array.

## Example

```powershell
$Queue = [System.Collections.Generic.List[string]]::new()
$Queue.Add('FS-01')
$Queue.Add('FS-02')
$Queue.Remove('FS-01')
$Queue.Count

$Servers = 'FS-01', 'FS-02'
$Servers += 'FS-03'
```

`Remove` prints True when it found something. `$null = $Queue.Remove(...)` suppresses that.
