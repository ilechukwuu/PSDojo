<#
Purpose: Morning report for print server PRN-01
Author:  Service desk
#>

#region Settings
$ServerName = 'PRN-01'
$Contact = 'service.desk@nordwind.example'
#endregion

#region Report
# Number of print queues counted on Monday
$QueueCount = 14
$ReportLine = "$ServerName has $QueueCount print queues"
#endregion
