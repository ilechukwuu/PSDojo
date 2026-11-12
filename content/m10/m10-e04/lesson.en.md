# Finding a misplaced format

The symptoms of a format cmdlet in the wrong place are easy to recognise once you have seen
them.

- A filter after it returns nothing.
- A sort after it changes nothing.
- A variable that should hold services holds something whose count is too high: a table of
  twelve rows is fourteen or more layout objects, because the header and the frame are
  objects too.
- `-ExpandProperty` reports that the property cannot be found.
- Joining the result as text gives long type names with Format in them.

The repair is always one of two.

If the data is needed afterwards, in a variable, a filter or an export, the format has to
go completely. Use `Select-Object` if you only want certain properties.

If the result is only shown, move the format to the end of the pipeline.

## Example

```powershell
$Names = Get-Service | Format-List -Property Name | Select-Object -ExpandProperty Name

$Names = Get-Service | Select-Object -ExpandProperty Name
```

Line 1 fails, because after the format there is no property Name. Line 3 needs no format at
all: the variable is not for the eye.
