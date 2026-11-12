# Registrierung und Zertifikate

Unter Windows sind zwei weitere Provider für Administratoren wichtig.

**Registrierung.** `HKLM:` ist der Zweig HKEY_LOCAL_MACHINE mit Einstellungen für den ganzen
Rechner, `HKCU:` ist HKEY_CURRENT_USER mit Einstellungen des angemeldeten Benutzers. Ein
Registrierungsschlüssel verhält sich wie ein Ordner: `Get-ChildItem` listet seine
Unterschlüssel. Die Werte in einem Schlüssel sind keine Items. Sie sind Eigenschaften des
Schlüssels, und du liest sie mit `Get-ItemProperty`.

**Zertifikate.** `Cert:` hat oben zwei Speicher: `Cert:\LocalMachine` und
`Cert:\CurrentUser`. Darunter enthält `My` die eigenen Zertifikate, also die, die ein Server
für HTTPS oder RDP benutzt. Jedes Zertifikat ist ein Item mit Eigenschaften wie `Subject`,
`Thumbprint` und `NotAfter`, dem Ablaufdatum.

Lesen ist harmlos. Die Registrierung ändern oder Zertifikate entfernen ist es nicht, darum
geht es in Modul 46.

Beide Provider gibt es nur unter Windows.

## Beispiel

```powershell
Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
Get-ChildItem -Path Cert:\LocalMachine\My
```

Zeile 1 listet Unterschlüssel, Zeile 2 liest die Werte eines Schlüssels, Zeile 3 listet die
Zertifikate des Rechners.
