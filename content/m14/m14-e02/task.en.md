# Task

A report mail shows strange texts. You look at the lines that build them. Predict the exact
text each line produces. Do not run anything.

```powershell
$Server = 'PRN-01'
$Queue = [pscustomobject]@{ Jobs = 14 }

"Server: $Server"
'Server: $Server'
"Jobs: $Queue.Jobs"
"Jobs: $($Queue.Jobs)"
"$Server_report.txt"
"$($Server.ToLower()).nordwind.example"
```

Store the six texts in `$Text1` to `$Text6`, in the order of lines 4 to 9. Use single
quotes for your answers so that nothing is replaced in them.
