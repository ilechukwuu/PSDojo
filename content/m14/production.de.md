# Was in der Produktion schiefgeht

Ein Aufräumskript baut den Pfad zum temporären Ordner eines Benutzers und leert ihn:

```powershell
$Target = "D:\Profiles\$User.Name\Temp"
Remove-Item -Path "$Target\*" -Recurse -Force
```

In doppelten Anführungszeichen ersetzt PowerShell nur die Variable, nicht die Eigenschaft
hinter dem Punkt. Aus `$User.Name` wird das ganze Objekt als Text, gefolgt von den wörtlichen
Zeichen `.Name`. Bei einem Benutzer ist dieser Text zufällig leer. Der Pfad schrumpft zu
`D:\Profiles\\Temp\*`, und auf dem nächsten Server, wo die Variable ganz leer ist, zu etwas
weit Schlimmerem.

Eine Eigenschaft in einem Text braucht `$( )` um sich herum. Und bevor ein aus Variablen
gebauter Pfad in einen löschenden Befehl geht, prüfe, dass der Pfad existiert und der
gemeinte ist.
