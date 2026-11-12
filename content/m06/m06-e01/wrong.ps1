# What does a date object offer?

$Members = Get-Date | Get-Member
$Properties = Get-Date | Get-Member -MemberType Method
$Methods = Get-Date | Get-Member -MemberType Property
$TypeName = 'System.DateTime'
