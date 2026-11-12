# Früh filtern

`Where-Object` filtert im Nachhinein. Der erste Befehl hat dann schon jedes Objekt geholt,
vielleicht Tausende von einem entfernten Server, und die meisten werden wieder verworfen.

Viele Befehle können an der Quelle filtern, mit einem eigenen Parameter:
`Get-Service -Name Nordwind*`, `Get-ChildItem -Filter *.log`, `Get-Process -Name sql*`. Der
Befehl holt dann nur, was gewünscht ist. Auf einer Dateifreigabe oder gegen Active Directory
sind das Sekunden statt Minuten.

Die Regel hat einen Namen: filter left. Setze das Filtern in der Pipeline so weit nach links
wie möglich.

- Schau zuerst auf die Parameter des ersten Befehls. `Get-Help` zeigt sie.
- Nutze `Where-Object` nur für Bedingungen, die kein Parameter abdeckt, etwa den Status eines
  Dienstes.

Beides lässt sich kombinieren: mit dem Parameter eingrenzen, dann den Rest filtern.

## Beispiel

```powershell
Get-Service | Where-Object { $_.Name -like 'Nordwind*' -and $_.Status -eq 'Stopped' }

Get-Service -Name Nordwind* | Where-Object { $_.Status -eq 'Stopped' }
```

Beide liefern dieselben Dienste. Die zweite Zeile fragt nur nach drei Diensten statt nach
allen.
