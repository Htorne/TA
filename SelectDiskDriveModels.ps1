# By Max Enroth
# maxenrothdk@gmail.com
param([int]$selection)
$Day= (Get-Date).Day 
$Month = (Get-Date).Month
$Year = (Get-Date).Year
$Hour = (Get-Date).Hour
$Minute = (Get-Date).Minute
$Second = (Get-Date).Second
$DateStamp = (Get-Date).DateTime
$Diskname = Get-WmiObject win32_diskdrive
$CPUname = Get-WmiObject win32_processor
$System = Get-WmiObject win32_ComputerSystem
$Memory = ($System.TotalPhysicalMemory/1Gb)
$counter = 0

#The selection of HDD is made in batchman.bat 
#before the start of each experiment

foreach ($objname in $CPUname)
{
Write-Host $objname.Name
$OutCPUName = $objname.Name
}

foreach ($objname in $Diskname)
{

if ($selection -eq $counter) {
write-host  $objname.Model
$OutDiskName = $objname.Model
 } 

 $counter++
}

Write-Host "$Day-$Month-$Year@$Hour-$Minute-$Second"
Write-Host "$Memory GB of physical memory" 

$FileName = "$Day-$Month-$Year@$Hour-$Minute-$Second"
Out-File -FilePath "C:\Project15\Tests\$Filename.txt"
Write-Host $OutCPUName
Add-Content C:\Project15\Tests\$Filename.txt "# System Info
# CPU:$OutCPUName
# RAM:$Memory GB of Physical RAM
# HDD:$OutDiskName
#
# Experiment Details
# DATE: $DateStamp
# Total Number of transactions
# Total Number of concurrent threads
##########################################
"

#Old CODE
#$ProcessActive = Get-Process calc -ErrorAction SilentlyContinue
#if($ProcessActive -eq $null){
#Write-host "Program is not running"
#}
#else
#{
#write-host "Program is running"
#}
Get-counter "\Processor(*)\% Processor Time" -SampleInterval 1 -Continuous | Export-counter -Path C:\Project15\Tests\$filename.csv -FileFormat "csv"