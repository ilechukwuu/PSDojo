# Stub functions for commands that do not exist on every platform or without RSAT.
# tests.ps1 dot sources this file and then replaces the commands with Pester mocks,
# so no exercise ever touches a real service, domain, share or registry.

if (-not (Get-Command -Name Get-Service -ErrorAction SilentlyContinue)) {
    function Get-Service {
        [CmdletBinding()]
        param(
            [Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
            [Alias('ServiceName')]
            [string[]]$Name,

            [Parameter()]
            [string[]]$DisplayName,

            [Parameter()]
            [string[]]$Include,

            [Parameter()]
            [string[]]$Exclude
        )

        process {
        }
    }
}
