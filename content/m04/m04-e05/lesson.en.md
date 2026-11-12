# The current location

Every session has a current location, the place where relative paths start. `Get-Location`
shows it, `Set-Location` changes it. `cd` is an alias for `Set-Location`.

In the console you move around all the time. A script should not, for three reasons:

- If `Set-Location` fails, the following commands run in the wrong place.
- The script leaves the session somewhere else than it found it. The next script or the
  person at the console gets a surprise.
- A relative path like `reports` means something different depending on where the script
  was started. As a scheduled task that is usually the system folder.

The fix is to give every command a full path. Build it from a variable that holds the root
folder. Inside double quotes PowerShell replaces the variable with its value.

`.` stands for the current location and `..` for the one above it.

## Example

```powershell
Set-Location -Path $Root
$Files = Get-ChildItem -Path reports

$Files = Get-ChildItem -Path "$Root/reports"
```

Lines 1 and 2 depend on where the session is. Line 4 returns the same files and leaves the
location alone.
