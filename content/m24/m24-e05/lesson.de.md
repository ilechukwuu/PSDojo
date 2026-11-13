# Eine Tabelle von Aktionen

Ein Skript, das je nach Name Verschiedenes tut, beginnt meist als `if`-Kette oder `switch`.
Jeder neue Fall fügt mitten in der Logik einen weiteren Zweig hinzu.

Skriptblöcke erlauben eine andere Form. Lege pro Name einen Block in eine Hashtable. Das
Skript hat dann zwei getrennte Teile:

- **die Tabelle**, die sagt, was es gibt und was jeder Eintrag tut
- **eine Zeile**, die den Block über den Namen nachschlägt und ausführt

`& $Checks[$CheckName] $Value`

Einen Fall zu ergänzen heisst, der Tabelle eine Zeile hinzuzufügen. Die Zeile, die ihn
ausführt, ändert sich nie. Und die Tabelle ist Daten: `$Checks.Keys` listet alle verfügbaren
Namen, für einen Hilfetext oder zur Prüfung von Eingaben.

Ein Name, der nicht in der Tabelle steht, liefert `$null`, und `$null` aufzurufen ist ein
Fehler. Prüfe mit `$Checks.ContainsKey($CheckName)`, wenn der Name von aussen kommt.

## Beispiel

```powershell
$Actions = @{
    Upper = { param($Text) $Text.ToUpper() }
    Lower = { param($Text) $Text.ToLower() }
    Trim  = { param($Text) $Text.Trim() }
}

& $Actions['Upper'] 'fs-01'
```
