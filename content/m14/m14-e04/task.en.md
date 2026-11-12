# Task

A monitoring tool hands your script a server name in a messy form. You clean it up and
write the text for the ticket. The first lines of your exercise file hold the input. Leave
them as they are.

1. Remove the spaces around `$RawName` and store the result in `$Fqdn`.
2. Store the part of `$Fqdn` in front of the first dot, in upper case, in `$ShortName`.
3. Store in `$IsInternal` whether `$Fqdn` ends with `.nordwind.example`.
4. Store a here-string with exactly these three lines in `$Body`. Insert `$ShortName` and
   `$FreeGB`:

```powershell
Ticket for FS-02
Drive "D:" has 12 GB free.
Please extend the volume.
```
