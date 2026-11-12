# Registry and certificates

On Windows two more providers matter to administrators.

**Registry.** `HKLM:` is the hive HKEY_LOCAL_MACHINE with settings for the whole machine,
`HKCU:` is HKEY_CURRENT_USER with settings for the signed-in user. A registry key behaves
like a folder: `Get-ChildItem` lists its subkeys. The values inside a key are not items.
They are properties of the key, and you read them with `Get-ItemProperty`.

**Certificates.** `Cert:` has two stores at the top: `Cert:\LocalMachine` and
`Cert:\CurrentUser`. Below them `My` holds personal certificates, the ones a server uses
for HTTPS or RDP. Each certificate is an item with properties such as `Subject`,
`Thumbprint` and `NotAfter`, the expiry date.

Reading is harmless. Changing the registry or removing certificates is not, and module 46
deals with that.

Both providers exist only on Windows.

## Example

```powershell
Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
Get-ChildItem -Path Cert:\LocalMachine\My
```

Line 1 lists subkeys, line 2 reads the values of one key, line 3 lists the certificates of
the machine.
