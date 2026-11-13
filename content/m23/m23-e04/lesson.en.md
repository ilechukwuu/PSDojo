# Execution policy

On Windows the execution policy decides whether PowerShell runs script files at all. The
common values:

- `Restricted`: no scripts. Default on Windows clients.
- `RemoteSigned`: local scripts run, downloaded ones need a signature. Default on Windows
  Server.
- `AllSigned`: every script needs a trusted signature.
- `Bypass`: nothing is blocked.

The policy can be set in five places. `Get-ExecutionPolicy -List` shows them in order of
precedence: `MachinePolicy` and `UserPolicy` (both set by Group Policy), `Process`,
`CurrentUser`, `LocalMachine`. The first one that is not `Undefined` wins. That is why
`Set-ExecutionPolicy` seems to do nothing on a machine governed by Group Policy.

A downloaded file carries a mark. `Unblock-File` removes it after you have read the script.

The execution policy is a safety belt against accidents, not a security boundary. Anyone
can paste the content of a script into the console. On Linux and macOS PowerShell 7 always
reports `Unrestricted`, and the policy cannot be changed.

## Example

```powershell
Get-ExecutionPolicy -List

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
