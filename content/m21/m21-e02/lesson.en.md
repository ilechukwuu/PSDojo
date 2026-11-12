# JSON

JSON is the format of configuration files and web services. Unlike CSV it can nest: a
value can be a list or another object with values of its own, and numbers and booleans keep
their type.

**Reading.** Read the whole file as one text and pipe it into `ConvertFrom-Json`:

`Get-Content -Path config.json -Raw | ConvertFrom-Json`

`-Raw` matters. Without it `Get-Content` returns the lines one by one. The result is an
object. Nested parts are reached with dots, lists with an index, and a property read on a
list returns it from every element.

**Writing.** `ConvertTo-Json` turns objects into JSON text. Its default depth is 2. Parts
that lie deeper are not converted properly: they become a text with the type name. Pass
`-Depth` with a value that is large enough, for example 5.

To save, pipe the text into `Set-Content` with `-Encoding UTF8`.

## Example

```powershell
$Config = Get-Content -Path D:\Config\monitor.json -Raw | ConvertFrom-Json
$Config.thresholds.warnPercent
$Config.servers[0].name
$Config.servers.name

$Config | ConvertTo-Json -Depth 5 | Set-Content -Path D:\Config\copy.json -Encoding UTF8
```
