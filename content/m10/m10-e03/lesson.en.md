# Out-File and Out-String

Sometimes a person, not a program, will read the result later: a text file attached to a
ticket, a mail body. Then you want exactly what the screen would show, as text.

- `Out-File -FilePath` writes it to a file. An existing file is overwritten, `-Append`
  adds to the end instead.
- `Out-String` returns it as one text that you can store in a variable or put into a mail.

Both draw for an imaginary screen. In a script without a window that screen is 80 or 120
characters wide, and wider tables are cut off or lose columns. Give `-Width` a generous
number to be safe.

`Out-File` also takes `-Encoding`. Windows PowerShell 5.1 writes UTF-16 by default, which
many programs show with gaps between the letters. PowerShell 7 writes UTF-8. Say
`-Encoding utf8` and both behave alike.

For data that a program reads, use `Export-Csv` instead. Module 21 covers that.

## Example

```powershell
Get-Service | Format-Table -Property Name, Status -AutoSize |
    Out-File -FilePath D:\Reports\services.txt -Encoding utf8 -Width 200

$Text = Get-Service | Format-Table -Property Name, Status | Out-String -Width 200
```
