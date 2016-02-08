$name = Get-WmiObject win32_diskdrive
$counter = 0


foreach ($objname in $name)
{

write-host "Drive ["$counter"]" $objname.Model
 
 
 $counter++
 



}

