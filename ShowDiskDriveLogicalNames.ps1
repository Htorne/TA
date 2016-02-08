$name = Get-WmiObject win32_LogicalDisk


foreach ($objname in $name)
{

$prettyname = $objname.DeviceID
Write-Host $prettyname.trim()


}