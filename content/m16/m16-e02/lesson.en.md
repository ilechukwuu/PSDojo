# One, none or many

The same line of code can return three different things, depending on how many results
there are.

- **Many**: an array. `Count` and `[0]` do what you expect.
- **Exactly one**: the object itself, not an array with one element. `[0]` then goes to the
  object. On a text it returns the first character, because a text is a list of
  characters.
- **None**: `$null`. `[0]` on `$null` is an error.

The cure is `@( )`, the array operator. Whatever is inside comes out as an array: several
elements stay several, one becomes an array with one element, nothing becomes an empty
array with `Count` 0.

Two arrays can be joined with `+`. The result is a new array with all elements.

In Windows PowerShell 5.1 `Count` of a single custom object is empty. With `@( )` the
question never comes up.

## Example

```powershell
$One = 'FS-01'
$One[0]
@($One)[0]
@($One).Count
@().Count
('FS-01', 'FS-02') + 'FS-03'
```

The results are F, FS-01, 1, 0 and an array with three servers.
