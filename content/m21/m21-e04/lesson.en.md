# XML

XML is the older sibling of JSON. Many Windows tools, scheduled task exports and
configuration files still use it. It nests elements in angle brackets, and an element can
carry attributes.

To read a file, load its text and cast it:

`[xml]$Doc = Get-Content -Path inventory.xml -Raw`

From the document you walk down with dots. Each element name is a property, and so is each
attribute. Several elements with the same name come back as a list, so the usual tools
apply: `Where-Object`, `Count`, a property read on the list.

As with CSV, every value is text.

For larger documents `Select-Xml -XPath` finds elements anywhere without walking down.
`//server[@site='Kiel']` means every element named server whose attribute site is Kiel.
Each result has a property `Node` with the element.

Element and attribute names are case-sensitive in XPath, though not with dots.

## Example

```powershell
[xml]$Doc = Get-Content -Path D:\Config\inventory.xml -Raw
$Doc.inventory.server
$Doc.inventory.server.name

Select-Xml -Xml $Doc -XPath "//server[@site='Kiel']" | ForEach-Object { $_.Node.name }
```
