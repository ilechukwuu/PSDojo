param($SolutionPath)

Describe 'Space taken by old log files' {
    BeforeAll {
        $folder = Join-Path -Path $TestDrive -ChildPath 'applogs'
        $sub = Join-Path -Path $folder -ChildPath 'sync'
        $null = New-Item -Path $sub -ItemType Directory -Force
        $files = @(
            @{ Path = (Join-Path -Path $folder -ChildPath 'api.log'); Size = 1000; Days = 40 }
            @{ Path = (Join-Path -Path $sub -ChildPath 'sync-old.log'); Size = 3000; Days = 90 }
            @{ Path = (Join-Path -Path $sub -ChildPath 'sync-today.log'); Size = 5000; Days = 0 }
            @{ Path = (Join-Path -Path $sub -ChildPath 'notes.txt'); Size = 9000; Days = 90 }
        )
        foreach ($file in $files) {
            [System.IO.File]::WriteAllBytes($file.Path, (New-Object -TypeName byte[] -ArgumentList $file.Size))
            (Get-Item -LiteralPath $file.Path).LastWriteTime = (Get-Date).AddDays(-$file.Days)
        }
        $null = New-Item -Path (Join-Path -Path $folder -ChildPath 'old.log') -ItemType Directory -Force
        . $SolutionPath -Root $folder
    }

    It 'Logs holds the three log files from all subfolders' {
        (@($Logs).Name | Sort-Object) -join ', ' | Should -Be 'api.log, sync-old.log, sync-today.log' -Because 'only files with the extension .log count, and -Recurse is needed to reach the subfolder sync'
    }

    It 'OldLogs holds the two files older than 30 days' {
        (@($OldLogs).Name | Sort-Object) -join ', ' | Should -Be 'api.log, sync-old.log' -Because 'LastWriteTime is compared with the date 30 days ago'
    }

    It 'TotalBytes is the sum of their sizes' {
        $TotalBytes | Should -Be 4000 -Because 'Measure-Object -Property Length -Sum adds the sizes in bytes'
    }

    It 'Largest is the name of the largest old file' {
        $Largest | Should -Be 'sync-old.log' -Because 'sorted by Length descending the largest file comes first, and only its Name is wanted'
    }
}
