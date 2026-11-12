# Eigene Laufwerke

`New-PSDrive` legt ein Laufwerk an. Es braucht drei Angaben: einen Namen mit `-Name`, den
Provider dahinter mit `-PSProvider` und eine Wurzel mit `-Root`, den Ort, an dem das Laufwerk
beginnt. Danach funktioniert der Name mit Doppelpunkt als Anfang eines Pfads.

Das hilft, wenn ein langer Pfad immer wieder gebraucht wird. Ein Laufwerk `Reports`, das auf
`\\FS-02\Data\Finance\Reports` zeigt, macht aus jedem Pfad `Reports:\2026`.

Was du wissen musst:

- Der Laufwerksname ist nicht auf einen Buchstaben beschränkt.
- Ein PowerShell-Laufwerk existiert nur in der aktuellen Sitzung und nur für PowerShell. Der
  Explorer und andere Programme sehen es nicht. Der Schalter `-Persist` legt stattdessen ein
  echtes verbundenes Netzlaufwerk an, nur unter Windows und nur mit einem Buchstaben.
- `Remove-PSDrive` entfernt das Laufwerk. Die Daten dahinter bleiben unberührt.

## Beispiel

```powershell
New-PSDrive -Name Reports -PSProvider FileSystem -Root '\\FS-02\Data\Finance\Reports'
Get-ChildItem -Path Reports:
Remove-PSDrive -Name Reports
```

Zeile 2 listet den Ordner auf der Freigabe über das neue Laufwerk.
