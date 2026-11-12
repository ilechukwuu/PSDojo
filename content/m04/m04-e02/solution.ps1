$env:DOJO_SITE = 'Hamburg'

# Work with the Env: drive below this line.

$AllVariables = Get-ChildItem -Path Env:
$Site = (Get-Item -Path Env:DOJO_SITE).Value

$null = New-Item -Path Env:DOJO_TICKET -Value 'INC-4711' -Force

$TicketExists = Test-Path -Path Env:DOJO_TICKET
