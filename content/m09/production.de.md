# Was in der Produktion schiefgeht

Ein Berichtsskript kürzt die Ausgabe früh, damit es übersichtlich bleibt, und entscheidet
später, was zu tun ist:

```powershell
$Users = Get-ADUser -Filter * -Properties LastLogonDate | Select-Object -Property Name
$Users | Where-Object { $_.LastLogonDate -lt $Limit }
```

`Select-Object -Property Name` blendet die anderen Eigenschaften nicht aus. Es baut neue
Objekte, die nur einen Namen haben. `LastLogonDate` ist weg, der Vergleich sieht bei jedem
Benutzer einen leeren Wert, und ein leerer Wert ist kleiner als jedes Datum. Jedes Konto der
Domäne landet auf der Liste der veralteten Konten.

Wähle Eigenschaften am Ende einer Pipeline aus, wenn alles erledigt ist, was das ganze Objekt
braucht.
