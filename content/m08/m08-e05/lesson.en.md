# Filter left

`Where-Object` filters after the fact. The first command has already fetched every object,
perhaps thousands from a remote server, and most are thrown away again.

Many commands can filter at the source with a parameter of their own: `Get-Service -Name
Nordwind*`, `Get-ChildItem -Filter *.log`, `Get-Process -Name sql*`. The command then
fetches only what is wanted. On a file share or against Active Directory the difference is
seconds instead of minutes.

The rule has a name: filter left. Put the filtering as far to the left of the pipeline as
it can go.

- First look at the parameters of the first command. `Get-Help` shows them.
- Use `Where-Object` only for conditions that no parameter covers, such as the status of a
  service.

Both can be combined: narrow down with the parameter, then filter the rest.

## Example

```powershell
Get-Service | Where-Object { $_.Name -like 'Nordwind*' -and $_.Status -eq 'Stopped' }

Get-Service -Name Nordwind* | Where-Object { $_.Status -eq 'Stopped' }
```

Both return the same services. The second asks only for three services instead of all.
