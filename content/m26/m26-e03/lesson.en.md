# What happens at the call

When you call an advanced function, PowerShell works through each argument in a fixed
order before your code runs.

1. **Find the parameter.** By name or by position. An unknown name is an error.
2. **Convert the type.** A text `'25'` for an `[int]` parameter becomes the number 25. A
   decimal number for `[int]` is rounded, so `2.7` becomes 3. What cannot be converted,
   such as `'many'`, is an error.
3. **Validate.** The attributes check the converted value. `ValidateSet` compares without
   regard to case. `ValidateRange` includes both limits.
4. **Check mandatory parameters.** If one is missing, an interactive console asks for it.
   A non-interactive session reports an error.

Default values are not validated. A default outside its own `ValidateRange` is accepted
without complaint, so check your defaults yourself.

Only when all of this has succeeded does the first line of the body run.

## Example

```powershell
function Get-Sample {
    [CmdletBinding()]
    param(
        [ValidateRange(1, 10)]
        [int]$Count = 5
    )
    $Count
}

Get-Sample -Count '7'
Get-Sample -Count 10
Get-Sample -Count 11
```

The first two calls return 7 and 10. The third is rejected.
