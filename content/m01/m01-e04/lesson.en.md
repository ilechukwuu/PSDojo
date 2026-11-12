# Read error messages

Red text is not a disaster. It is PowerShell telling you exactly what it did not understand.
Read the first sentence, it names the culprit.

Three beginner mistakes cause most errors:

- A typo in the cmdlet name. The message says the term is not recognized as the name of a
  cmdlet.
- A typo in a parameter name. The message says a parameter cannot be found that matches the
  name.
- A missing hyphen in front of a parameter. PowerShell then treats the word as a value, and
  the message complains about that value.

Upper and lower case do not matter: `get-process` works. Write names the way the cmdlet
shows them anyway, it reads better.

The wording of error messages differs slightly between Windows PowerShell 5.1 and
PowerShell 7. The meaning is the same.

## Example

```powershell
Get-Procces -Name spoolsv
# The term 'Get-Procces' is not recognized as a name of a cmdlet ...

Get-Process -Name spoolsv
```

The message quotes the misspelled name. Compare it letter by letter with what you meant.
