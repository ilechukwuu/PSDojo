# Task

The asset management exports the server inventory as XML. The dojo passes the folder as
`$Folder`. The file `inventory.xml` in it looks like this:

```powershell
<inventory>
  <server name="FS-01" site="Kiel"><ramGB>32</ramGB></server>
  <server name="FS-02" site="Hamburg"><ramGB>64</ramGB></server>
  <server name="PRN-01" site="Hamburg"><ramGB>16</ramGB></server>
</inventory>
```

1. Read the file into the XML document `$Doc`.
2. Store the list of server elements in `$Servers`.
3. Store the names of all servers in `$Names`.
4. Store the names of the servers whose site is `Hamburg` in `$HamburgNames`.
5. Store the total RAM of all servers as a whole number in `$TotalRam`.

Leave the line with `param` as it is.
