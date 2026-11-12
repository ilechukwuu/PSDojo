# What goes wrong in production

A script exports the configuration of all application servers to JSON so that it can be
restored after a rebuild:

```powershell
$Config | ConvertTo-Json | Set-Content -Path config.json
```

The restore fails months later. Where the firewall rules of each network adapter should be,
the file says `System.Collections.Hashtable`. `ConvertTo-Json` goes only two levels deep by
default and writes everything below that as a plain text with the type name. Windows
PowerShell 5.1 does this without any warning.

Always pass `-Depth` with a value that covers your data, and test a backup by reading it
back, not by checking that the file exists.
