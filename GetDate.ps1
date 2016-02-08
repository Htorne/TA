$Day= (Get-Date).Day 
$Month = (Get-Date).Month
$Year = (Get-Date).Year
$Hour = (Get-Date).Hour
$Minute = (Get-Date).Minute
$Second = (Get-Date).Second

$Query1 = "Select Model from Win32_diskdrive"
$ResultOfQuery1 = Get-WmiObject -Query $Query1


  
cls
Write-Host $DocumentName"-"$Month"-"$Year"@"$Hour$Minute$Second
-join $ResultOfQuery1
