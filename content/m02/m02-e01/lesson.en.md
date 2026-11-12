# Script pane and console

Both editors, the PowerShell ISE and VS Code with the PowerShell extension, have two areas.
In the script pane you write and save a file. In the console below it, commands run and
results appear. Both areas share one session, so a variable set by the script is available
in the console afterwards.

Two keys matter most, and they are the same in both editors:

- **F5** runs the whole file.
- **F8** runs only what you have selected. With nothing selected, VS Code runs the current
  line and ISE runs nothing.

F8 is how you explore: you try one line, look at the result, then try the next. It is also
the safe habit on a server, because F5 on a half-finished script runs every line in it.

The ISE only runs Windows PowerShell 5.1. VS Code runs 5.1 and PowerShell 7.

## Example

```powershell
Get-Date
Get-Process -Name spoolsv
```

Click into the first line and select it. F8 prints the date and nothing else. F5 would run
both lines.
