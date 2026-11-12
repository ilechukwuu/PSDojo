# Task

A disk report for the file servers behaves strangely. You suspect its comparisons. Predict
what each line returns and store `$true` or `$false`. Do not run the lines.

```powershell
'PRN-01' -eq 'prn-01'
'100' -gt '25'
100 -gt '25'
'FS-02.nordwind.example' -eq 'FS-02*'
'FS-02.nordwind.example' -like 'FS-0?.*'
'C:', 'D:' -contains 'd:'
```

Store the six results in `$Result1` to `$Result6`, in the order of the lines.
