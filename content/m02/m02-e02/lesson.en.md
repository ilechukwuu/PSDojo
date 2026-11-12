# Comments and regions

A script is read far more often than it is written. Comments tell the reader what the code
cannot say: why it exists and what to watch out for.

- `#` starts a comment that runs to the end of the line.
- `<#` and `#>` enclose a block comment over several lines. A block comment at the very top
  is the usual place for purpose and author.
- `#region Name` and `#endregion` mark a section. Both editors show a small arrow next to
  the region so that you can fold it away. PowerShell itself ignores the two markers, they
  are comments.

Write `#region` without a space after the hash, otherwise the editor does not fold it.

In both editors Ctrl+J opens a list of snippets, ready-made blocks such as a block comment
or a region.

## Example

```powershell
<#
Purpose: Morning check for PRN-01
Author:  Service desk
#>

#region Settings
$ServerName = 'PRN-01'   # the print server
#endregion
```

The header says what the file is for. The region groups the settings.
