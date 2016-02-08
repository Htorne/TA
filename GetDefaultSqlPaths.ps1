[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null
$s = New-Object ('Microsoft.SqlServer.Management.Smo.Server') "LOCALHOST" 
$s | Get-Member -MemberType Property 
$s.Settings | Get-Member -MemberType Property
#$s.Settings.BackupDirectory
$s.Settings.DefaultFile
$s.Settings.BackupDirectory
$s.Settings.DefaultLog