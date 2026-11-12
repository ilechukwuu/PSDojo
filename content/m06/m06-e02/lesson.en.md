# Reading properties

A property is read with a dot: the object, a dot, the property name. No spaces.

The object can be in a variable, or you put a command in parentheses and read from its
result directly. The parentheses make PowerShell run the command first.

The value of a property is again an object with a type of its own. `Length` of a file is a
number, `LastWriteTime` is a date, and `Directory` is a folder object that has properties
again. So dots can be chained: file, its folder, the folder's name.

Property names are not case-sensitive. If you ask for a property that does not exist you
get nothing back and, by default, no error. A typo therefore shows up as an empty value
much later. `Get-Member` protects you from that.

## Example

```powershell
$File = Get-Item -Path D:\Reports\usage.csv
$File.Length
$File.LastWriteTime.Year
$File.Directory.Name

(Get-Item -Path D:\Reports\usage.csv).Extension
```

Line 3 reads the date and from it the year. Line 4 reads the folder and from it the name.
