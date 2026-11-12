# Verb-Noun

Every cmdlet name has the same shape: a verb, a hyphen, a noun. The verb says what happens,
the noun says to what. Once you know the pattern you can read commands you have never seen.

The verbs come from a fixed list that `Get-Verb` shows. The ones you meet daily:

- `Get` reads. It never changes anything, so it is safe to try.
- `Set` changes something that exists.
- `New` creates, `Remove` deletes.
- `Start`, `Stop` and `Restart` control things that run.

The noun is always singular: `Get-Service`, not `Get-Services`, even though it returns many.

Because the pattern is reliable you can guess. If `Get-Service` and `Stop-Service` exist,
`Restart-Service` probably exists too.

Service cmdlets exist only on Windows.

## Example

```powershell
Get-Service -Name Spooler
Restart-Service -Name Spooler
```

The first line only reads the state of the print spooler. The second line changes the
server: every print job in the queue is interrupted.
