# What goes wrong in production

A script builds a report of all file shares and exports it for the auditors:

```powershell
$Row = @{ Server = 'FS-02'; Share = 'Finance'; SizeGB = 410 }
$Row | Export-Csv -Path shares.csv
```

The CSV file contains columns named IsReadOnly, IsFixedSize, Keys, Values and Count. Those
are the properties of the hashtable itself, not of the data in it. The auditors receive a
file that says nothing about any share.

A hashtable is a container for looking things up. A report row is an object with
properties. Put `[pscustomobject]` in front of the hashtable and the same three values
become three columns.
