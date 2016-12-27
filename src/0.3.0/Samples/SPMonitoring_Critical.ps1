﻿Import-Module "C:\Development\GitHub\PoShMon\PoShMon\src\0.2.0\PoShMon.psd1" #This is only necessary if you haven't installed the module into your Modules folder, e.g. via PowerShellGallery / Install-Module

$eventLogCodes = "Critical"
$WebtestDetails = @{ "http://intranet" = "something on the page"; "http://extranet.company.com" = "Something on the page" }
$TestsToSkip = @('SPDatabaseHealth')

Invoke-SPMonitoring -EnvironmentName "SharePoint" -MinutesToScanHistory 15 -PrimaryServerName 'SPAPPSVR01' -MailToList "SharePointTeam@Company.com" -EventLogCodes $eventLogCodes -TestsToSkip $TestsToSkip -WebsiteDetails $WebtestDetails -SendMailWhen "OnlyOnFailure" -MailFrom "Monitoring@company.com" -SMTPAddress "EXCHANGE.COMPANY.COM" -Verbose

Invoke-OSMonitoring -EnvironmentName "Office Web Apps" -MinutesToScanHistory 15 -ServerNames 'OWASVR01' -MailToList $mailTos -EventLogCodes $eventLogCodes -TestsToSkip $TestsToSkip -SendMailWhen "OnlyOnFailure" -MailFrom "Monitoring@company.com" -SMTPAddress "EXCHANGE.COMPANY.COM" -Verbose

#Remove-Module PoShMon