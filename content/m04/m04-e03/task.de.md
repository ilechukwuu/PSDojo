# Aufgabe

Für ein Audit des Webservers WEB-01 schickt dir ein Kollege die Befehle, die er verwenden
will, und fragt, ob sie liefern, was er erwartet. Führe nichts aus. Antworte mit dem, was du
über die beiden Provider weißt.

```powershell
Get-ChildItem -Path HKLM:\SOFTWARE\Nordwind
Get-ItemProperty -Path HKLM:\SOFTWARE\Nordwind\Backup
Get-ChildItem -Path Cert:\LocalMachine\My
Get-ChildItem -Path HKCU:\Printers
```

1. Welche der vier Zeilen liefert die Werte, die in einem Registrierungsschlüssel stehen,
   zum Beispiel die Backup-Uhrzeit? Speichere ihre Nummer in `$ValueLine`.
2. Welche Zeile liefert Zertifikate? Speichere ihre Nummer in `$CertificateLine`.
3. Welche Zeile liest Einstellungen, die nur dem angemeldeten Benutzer gehören? Speichere
   ihre Nummer in `$UserLine`.
4. Welche Eigenschaft eines Zertifikats sagt dir, wann es abläuft? Speichere ihren Namen als
   Text in `$ExpiryProperty`.
