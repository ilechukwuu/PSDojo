# XML

XML ist der ältere Verwandte von JSON. Viele Windows-Werkzeuge, Exporte geplanter Aufgaben
und Konfigurationsdateien benutzen es noch. Es verschachtelt Elemente in spitzen Klammern,
und ein Element kann Attribute tragen.

Um eine Datei zu lesen, lade ihren Text und wandle ihn um:

`[xml]$Doc = Get-Content -Path inventory.xml -Raw`

Vom Dokument aus gehst du mit Punkten nach unten. Jeder Elementname ist eine Eigenschaft,
jedes Attribut ebenso. Mehrere Elemente mit demselben Namen kommen als Liste zurück, die
üblichen Werkzeuge gelten also: `Where-Object`, `Count`, eine Eigenschaft an der Liste.

Wie bei CSV ist jeder Wert Text.

In größeren Dokumenten findet `Select-Xml -XPath` Elemente irgendwo, ohne hinunterzugehen.
`//server[@site='Kiel']` heißt jedes Element namens server, dessen Attribut site Kiel ist.
Jedes Ergebnis hat eine Eigenschaft `Node` mit dem Element.

Element- und Attributnamen unterscheiden in XPath Groß- und Kleinschreibung, mit Punkten
nicht.

## Beispiel

```powershell
[xml]$Doc = Get-Content -Path D:\Config\inventory.xml -Raw
$Doc.inventory.server
$Doc.inventory.server.name

Select-Xml -Xml $Doc -XPath "//server[@site='Kiel']" | ForEach-Object { $_.Node.name }
```
