# Get-Help

PowerShell documents itself. `Get-Help` shows the help for any command, right where you
work, without a browser.

- `Get-Help -Name Stop-Process` shows the short version: what the command does and how it
  is called.
- `-Examples` shows only the examples. That is usually the fastest way to learn a command.
- `-Parameter Force` shows the details of one parameter. `-Parameter *` shows all of them.
- `-Full` shows everything, `-Online` opens the current page in the browser.

Like every cmdlet, `Get-Help` returns an object. You can store it and read its properties,
for example `Name`.

The detailed texts are not always installed. `Update-Help` downloads them, which needs
internet access and, in Windows PowerShell 5.1, an elevated console. Without them
`Get-Help` still shows the syntax and the parameter details, because PowerShell reads those
from the command itself.

## Example

```powershell
Get-Help -Name Stop-Process
Get-Help -Name Stop-Process -Examples
Get-Help -Name Stop-Process -Parameter Force
```

The third line answers one precise question: what exactly does `-Force` do here?
