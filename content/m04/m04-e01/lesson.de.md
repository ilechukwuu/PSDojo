# Provider und Laufwerke

In PowerShell ist ein Laufwerk mehr als eine Festplatte. Ein Provider ist ein Adapter, der
einen Datenspeicher als Laufwerk bereitstellt, sodass du darin wie in Ordnern navigierst.
Dieselben Cmdlets funktionieren dann überall.

Provider, die dir begegnen:

- `FileSystem`: Datenträger und Freigaben, Laufwerke wie `C:`.
- `Environment`: Umgebungsvariablen, Laufwerk `Env:`.
- `Alias`, `Variable`, `Function`: was die aktuelle Sitzung kennt.
- `Registry`: die Windows-Registrierung, Laufwerke `HKLM:` und `HKCU:`.
- `Certificate`: die Windows-Zertifikatspeicher, Laufwerk `Cert:`.

`Get-PSProvider` listet die Provider, `Get-PSDrive` die Laufwerke. Ein Laufwerksobjekt kennt
seinen `Name`, seinen `Provider` und seine Wurzel `Root`.

Die Provider für Registrierung und Zertifikate gibt es nur unter Windows. Unter Linux und
macOS hat das Dateisystem ein einziges Laufwerk namens `/`.

## Beispiel

```powershell
Get-PSProvider
Get-PSDrive
Get-PSDrive -Name Env
Get-PSDrive -PSProvider FileSystem
```

Die letzte Zeile listet nur die Laufwerke, hinter denen der Dateisystem-Provider steht.
