
cls
#Get's content of LatestExperiment
$GetLatestExperimentName = Get-Content C:\Project15\Tests\LatestExperiment.txt
$Global:ExperimentID = $GetLatestExperimentName + ".png"
#Imports the CSV file for easy formatting and removes the commas
$TempImport = Import-Csv C:\Project15\Tests\$GetLatestExperimentName.csv
$TempImport | Out-File C:\Project15\Tests\$GetLatestExperimentName-Parsed.txt
#Graps anything interesting for plotting, in this case the CPU total.
$TempName = "C:\Project15\Tests\$GetLatestExperimentName-Parsed.txt"
$reader = [System.IO.File]::OpenText($TempName)


#Important to "reset" these variable as it remains alive after script stops!
$PreParsedText1 = ""
$PreParsedText2 = ""
$ParsedText1 = ""
$ParsedText2 = ""
$ParsedArrayed1 = ""
$ParsedArrayed2 = ""
$ArrayFixed = ""
$timer = 0


try {

# Not utillizing any of the paramerters that's why it says ;;
for(;;){
            #Assign $line with each read line in $reader
            $line = $reader.ReadLine()
                    #If a line in $line matches the patteren _total do the following
                    if ($line -match '_total')
                            {                            
                              #Add the selected line to $PreParsedText1
                              $PreParsedText1 += ($line+" ") 
                              $timer++                           
                              
                            } 
                     #If a line in $line matches the patteren PDH-CSV do the following
                     if ($line -match 'PDH-CSV')
                            {
                              
                              $PreParsedText2 += ($line+"`r`n")
                              #Add the selected line to $PreParsedText2
                            

                            }
                     
                     
                     #If EOF is reached do the following
                     if($line -eq $null)

                            {
                            break
                            # If stream is empty break out
                            }

                    #Required - process the line
                        $line
}

    }
    #Close the Input stream for good messure
finally {$reader.Close()
}

#Regex trimming of strings, in prepration of Hash Tabel intergration

#Key
$ParsedText1 = $PreParsedText1 -replace "\\\\$env:computername\\processor\(_total\)\\% processor time : ", ""
#Value
$ParsedText2 = $PreParsedText2 -replace "\(PDH-CSV 4.0\) \(Romance Daylight Time\)\(-120\) " ,""
$ParsedText2 = $PreParsedText2 -replace "\(PDH-CSV 4.0\) \(Romance Standard Time\)\(-60\)           :" ,""
#$ChartData.Add($Key,$Value)


#Moving strings into arrays using the -split function
$ParsedArrayed1 = -split $ParsedText1
$ParsedArrayed2 = $ParsedText2 -split "`r`n"

#Removing the first two array entries, since they are empty 99.9% of the time due to a wait call in the batchfile
#They are empty by design, allowing the transactions to start running before the benchmarking starts.
$ParsedArrayed2 = $ParsedArrayed2[1..($ParsedArrayed2.Length -2)]
Write-Host $ParsedArrayed1
Write-Host $ArrayFixed
#Counting the array sizes in prepration for the hash table data structure 
$ParsedArrayed1.Count 
$ParsedArrayed2.Count 

#The create_hash function does just that, merges two arrays of equal lenght into an 
#hash array
function create_hash ([array] $keys, [array] $values) {
    
    $Global:h =[ordered] @{}
    #Forces the Key-Value entries in the hash table to be ordered, in this case cronological 
    if ($keys.Length -ne $values.Length) {
        #If the arrays are of different lenght you need to adjust the array entry trimming lenght 
        #search this document for -2)] to find the location.
        Write-Error -Message "Array lengths do not match" `
                    -Category InvalidData `
                    -TargetObject $values
    } else {
        for ($i = 0; $i -lt $keys.Length; $i++) {
            $h[$keys[$i]] = $values[$i]
        }
    }
    return $h
}

#Run function create_hash - with Key and Value
create_hash $ParsedArrayed2 $ParsedArrayed1


# Load the appropriate assemblies
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")




# Create chart object
$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
$Chart.Width = 500
$Chart.Height = 400
$Chart.Left = 40
$Chart.Top = 30

# create a chartArea to draw on and add to chart
$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$Chart.ChartAreas.Add($ChartArea)



# Add data to chart

[void]$Chart.Series.Add("Data")
$Chart.Series["Data"].Points.DataBindXY($h.Keys, $h.Values)

        # set chart type
        $Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
        $Chart.Series["Data"].Color = [System.Drawing.Color]::Red

        # add title and axes labels
        $ChartTitle = Get-Content C:\Project15\Tests\LatestExperiment.txt
        [void]$Chart.Titles.Add("Experiment ID $ChartTitle")
        $ChartArea.AxisX.Title = "Time"
        $ChartArea.AxisY.Title = "CPU Time"
        $chartarea.AxisY.Interval = 50
        # $chartarea.AxisX.Interval = 1
        

        # change chart area colour
        $Chart.BackColor = [System.Drawing.Color]::Transparent

# display the chart on a form
$Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor
                [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left


#Graphing form features
$SaveButton = New-Object Windows.Forms.Button
$SaveButton.Text = "Save"
$SaveButton.Top = 400
$SaveButton.Left = 450
$SaveButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right

#Add save button to chart
$SaveButton.add_click({$Chart.SaveImage("C:\Project15\Graphs\"+$ExperimentID,"PNG")})

$Form = New-Object Windows.Forms.Form
$Form.Text = "PowerShell Chart"
$Form.Width = 600
$Form.Height = 500
$Form.controls.add($SaveButton)
$Form.controls.add($Chart)
$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()

#Append $timer to SystemInfo and perhaps rename SystemInfo.txt to ExperimentInfo.txt
$timer = $timer -1
Write-Host "Experiment ran for $timer seconds"
Add-Content C:\Project15\Tests\$GetLatestExperimentName-SystemInfo.txt "Experiment ran for $timer seconds"
Add-Content C:\Project15\Tests\$GetLatestExperimentName-SystemInfo.txt "This is the first line
This shoud be the second
and this the third"

 