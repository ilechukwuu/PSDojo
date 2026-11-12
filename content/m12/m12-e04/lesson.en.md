# Typical variable mistakes

**Calculating with text.** Two texts joined instead of added. The result looks like a
number, only far too large. Convert before you calculate.

**A cast that cannot work.** `[int]$Count = 'twelve'` stops with the message that the value
cannot be converted to System.Int32. The data is wrong, not the cast.

**A mistyped variable name.** `$ServerNmae` is not an error for PowerShell. It is a
different variable that nobody ever filled, so it is `$null`, and in a text it turns into
nothing. The script runs on and produces `Server: ` with nothing behind it.

The last one is the most common mistake in all of scripting. Two things protect you: let
the editor complete variable names with Tab instead of typing them, and later in this
course `Set-StrictMode`, which turns the use of an unset variable into an error.

## Example

```powershell
$ServerName = 'FS-02'
"Server: $ServerNmae"

"Server: $ServerName"
```

Line 2 prints `Server: ` because of the swapped letters. Line 4 prints `Server: FS-02`.
