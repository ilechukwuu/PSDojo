# Task

For an audit of web server WEB-01 a colleague sends you the commands he plans to use and
asks whether they will return what he expects. Do not run anything. Answer from what you
know about the two providers.

```powershell
Get-ChildItem -Path HKLM:\SOFTWARE\Nordwind
Get-ItemProperty -Path HKLM:\SOFTWARE\Nordwind\Backup
Get-ChildItem -Path Cert:\LocalMachine\My
Get-ChildItem -Path HKCU:\Printers
```

1. Which of the four lines returns the values stored in a registry key, for example the
   backup time? Store its number in `$ValueLine`.
2. Which line returns certificates? Store its number in `$CertificateLine`.
3. Which line reads settings that belong to the signed-in user only? Store its number in
   `$UserLine`.
4. Which property of a certificate tells you when it expires? Store its name as text in
   `$ExpiryProperty`.
