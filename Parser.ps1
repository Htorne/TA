cls
#Get's content of LatestExperiment
$GetLatestExperimentName = Get-Content C:\Project15\Tests\LatestExperiment.txt

#Imports the CSV file for easy formatting and removes the commas
$TempImport = Import-Csv C:\Project15\Tests\$GetLatestExperimentName.csv
$TempImport | Out-File C:\Project15\Tests\$GetLatestExperimentName-Parsed.txt 

#Graps anything interesting for plotting, in this case the CPU total.
#You can add any item you want HDD, RAM, etc. 
$TempName = "C:\Project15\Tests\$GetLatestExperimentName-Parsed.txt"
$reader = [System.IO.File]::OpenText($TempName)


#Important to reset this variable as it remains alive after script stops!
$ParsedText1 = ""
$ParsedText2 = ""


try {

for(;;){
            $line = $reader.ReadLine()
                    if ($line -match '_total')
                            {                            
                              $ParsedText1 += ($line+"`r`n") 
                              #Add any string that contains _Total to array and add newline                            
                            } 
                     
                     if ($line -match 'PDH-CSV')
                            {
                              $ParsedText2 += ($line+"`r`n")
                              #Pluck Time information out of stream
                            }
                     
                     
                     if($line -eq $null)
                            {
                            break
                            # If stream is empty break out
                            }

                    #Required - process the line
                        $line
}

    }
finally {$reader.Close()
}
$ParsedText1 -replace "\\\\$env:computername\\processor\(_total\)\\% processor time : ", ""
$ParsedText2 -replace "\(PDH-CSV 4.0\) \(Romance Daylight time\)\(-120\) : " ,""