# What goes wrong in production

A helpdesk tool compresses a folder that the technician types into a text box. To stay
flexible the author builds the command as text and runs it:

```powershell
Invoke-Expression "Compress-Archive -Path $Folder -DestinationPath D:\Out\data.zip"
```

It works for years. Then a folder is called `D:\Data; Remove-Item D:\Shares -Recurse`. The
text is run as two commands, with the rights of the tool. The same happens, less
dramatically, with every folder name that contains a space or a quote.

Text that is run as code is the most dangerous construct in PowerShell. Call the cmdlet
directly and pass values as parameters, with splatting if the parameters vary, or put the
logic in a script block. Then a value always stays a value.
