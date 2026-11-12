# Lookup tables

The most valuable use of a hashtable is translating one value into another: a server name
into its site, a status code into a readable text, a department into its cost centre.

Without it you would filter a list for every single question. With it the answer is one
step, and it stays one step when the table has ten thousand entries. That makes scripts
that match two data sources against each other fast.

The key does not have to be typed. It can come from a variable or a property:
`$SiteOf[$Server]`.

Three things to keep in mind:

- A key exists only once. Assigning it again overwrites.
- Looking up a key that is missing returns `$null`. Check with `ContainsKey` when a missing
  entry matters.
- Keys are compared without regard to case.

## Example

```powershell
$SiteOf = @{
    'FS-01' = 'Kiel'
    'FS-02' = 'Hamburg'
}

$Server = 'FS-02'
$SiteOf[$Server]
"$Server stands in $($SiteOf[$Server])"
```

Line 7 returns Hamburg. Inside a text the lookup needs `$( )`.
