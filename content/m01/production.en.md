# What goes wrong in production

A one-liner from a forum is pasted into a console on a production server. It is full of
aliases, so nobody reads what it really does:

```powershell
gsv | ? Status -eq Stopped | sasv
```

Decoded it says `Get-Service | Where-Object Status -eq Stopped | Start-Service`. It starts
every stopped service, including the ones that were disabled on purpose.

Before you run a foreign command on a server: resolve every alias with `Get-Alias`, read the
verbs, and stop as soon as you see anything other than `Get`.
