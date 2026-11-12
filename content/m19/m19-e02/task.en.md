# Task

The on-call engineer wants the state of the services on APP-01 as plain lines for a chat
message. Each service object has the properties `Name`, `Status` and `StartType`.

1. Store one text per service whose name starts with `Nordwind` in `$Lines`, in the form
   `NordwindApi is Running`. Use `Get-Service -Name Nordwind*` piped into `ForEach-Object`.
2. Store the names of all services that are `Stopped` in `$StoppedNames`, in upper case.
   Use a pipeline of `Get-Service`, `Where-Object` and `ForEach-Object`.
