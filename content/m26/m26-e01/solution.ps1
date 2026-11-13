# Which share of which file server is to be measured?

function Get-ShareUsage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ComputerName,

        [string]$Share = 'Data'
    )

    Write-Verbose -Message "Reading share $Share on $ComputerName"

    [pscustomobject]@{
        ComputerName = $ComputerName
        Share        = $Share
    }
}
