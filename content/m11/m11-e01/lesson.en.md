# Two kinds of output

A script produces two kinds of things, and PowerShell keeps them apart in separate
channels called streams.

**The result.** This is the data the script exists for. It goes to the success stream,
stream 1. Only this stream flows through the pipe and into a variable. `Write-Output` writes
to it, and so does every value that stands alone on a line. Most scripts never need to
write `Write-Output` at all.

**Messages for people.** A heading, a note that the check has finished. `Write-Host` writes
them to the screen. They are not part of the result: a variable that captures the script
does not contain them.

So the question is always who the text is for. If another command or a variable should get
it, it is a result. If only a person should read it, it is a message.

## Example

```powershell
Write-Host 'Service check for APP-01'
Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Select-Object -ExpandProperty Name
```

Run as a script and captured in a variable, the variable holds the service names. The
heading appears on screen and nowhere else.
