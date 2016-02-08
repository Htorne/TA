
#Recives user input for harddisk selection - used in loop around line 35
param([int]$selection, [int]$numberOfThreads, [int]$numberOfTransactions)

#The selection of HDD is made in batchman.bat 
#before the start of each experiment

#Getting Date, Time, All disk names, CPU model and total memory of the system
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
$counter = 0 #Counter is used for Disk selection



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

#Out-File -FilePath "C:\Project15\Tests\CPU $Filename.txt"
$FileName = "$Day-$Month-$Year@$Hour-$Minute-$Second"
$ModdifiedFileName = ($FileName)
$ModdifiedFileName | Out-File C:\Project15\Tests\LatestExperiment.txt

Write-Host "
############################
# Benchmarking now do not  #
# terminate experiment     #
# prematurely without also #
# terminating the          #
# Powershell process       #
############################ 
Log-file $Filename.txt
Performance csv file $Filename.csv
"
Add-Content C:\Project15\Tests\$Filename-SystemInfo.txt "# System Info
# CPU:$OutCPUName
# RAM:$Memory GB of Physical RAM
# HDD:$OutDiskName
#
# Experiment Details
# DATE: $DateStamp
# Total Number of transactions: $numberOfTransactions
# Total Number of concurrent threads $numberOfThreads
##########################################
"

#OLD CODE
#$ProcessActive = Get-Process calc -ErrorAction SilentlyContinue
#if($ProcessActive -eq $null){
#Write-host "Program is not running"
#}
#else
#{
#write-host "Program is running"
#}

Get-counter "\Processor(*)\% Processor Time" -SampleInterval 1 -Continuous | Export-counter -Path C:\Project15\Tests\$filename.csv -FileFormat "csv"
# OLD COUNTERS usefull if you wish to develop on this futhere - adding more options etc.
Get-Counter "\PhysicalDisk(1 D:)\Current Disk Queue Length" -SampleInterval 1 -Continuous | Export-counter -Path C:\Project15\Tests\$filename-Queue-On-D.csv -FileFormat "csv"
Get-Counter "\PhysicalDisk(2 E:)\Current Disk Queue Length" -SampleInterval 1 -Continuous | Export-counter -Path C:\Project15\Tests\$filename-Queue-On-E.csv -FileFormat "csv"
