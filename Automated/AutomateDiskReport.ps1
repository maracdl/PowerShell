#run the daily report

Param (
    [string]$Path = "C:\Users\mara_\Desktop\powershell\diskhistory.csv",
    [string]$ReportPath = "C:\Users\mara_\Desktop\powershell"
)

#import CSV
#verify the file exists
if (Test-Path -Path $Path) {
    #everything imported into a CSV is a string so rebuild as an object
    #withproperties of the correct type
    $data = Import-Csv -Path $Path | ForEach-Object {
        [PSCustomObject]@{
            ComputerName = $_.ComputerName
            DeviceID = $_.DeviceID
            SizeGB = ($_.size / 1GB) -as [int32]
            FreeGB = ($_.freespace / 1GB) 
            PctFree = $_.PctFree -as [double]
            Date = $_.Date -as [datetime]
        }
    }
    #group the history data by computername
    $grouped = $data | Group-Object -Property ComputerName    
}
else {
    #if Test-Path fails, display a warning and exit the script
    Write-Warning "Can't find $Path."
    #bail out of the script
    return 
}

#save the results to a text file report

<# $header is a here sting. This is a great way to create a multi-line
    string. The closing "@ must be left justified
#>

$header = @"
Disk History Report $((Get-Date).ToShortDateString())
**********************************
Data Source = $Path
*******************
Latest Check
************
"@

#get a timestamp value. -Format value is case-sensitive
$timestamp = Get-Date -Format yyyyMMdd
$OutputFile = "$timestamp-diskreport.txt"
$OutputPath = join-path -Path $ReportPath -ChildPath $OutputFile

#define a hashtable of parameters for Out-File
#this will be splatted
$outParams = @{
    FilePath = $OutputPath
    #Enconding = "ASCII"
    Append = $True
    Width = 120
}

#splat the parameter hashtable
$header | Out-File @outParams

#get the last entry for each computer
$latest = foreach ($computer in $grouped) {
    #nedd to report for each deviceId on each computer
    $devices = $computer.group | Group-Object -Property DeviceID
    $devices | ForEach-Object {
        $_.Group | Sort-Object Date -Descending | Select-Object -First 1
    }
}

#normally you wouldn't use Format cmdlets in a script. This is
#an exception because I want nicely formatted output in the text file
$latest | Sort-Object -Property ComputerName |
    Format-Table -AutoSize | Out-File @outParams

#report on serves with low disk space
$header = @"
****************
Low Diskpace <=30%
**************8
"@

$header | Out-File @outParams
$latest | Where-Object {$_.PctFree -le 30} | Sort-Object -Property ComputerName
    Format-Table =-AutoSize | Out-File @outParams

#report trending
#need to report for each deviceID on each computer
#group the data by a custom property. This may be a little advanced.
$all = $data | Group-Object -Property {"$($_.ComputerName) $($_.DeviceID)"}

$header = @"
****************************
Change Percent between last 2 reports
****************************
"@
$header | Out-File @outParams

$all | ForEach-Object {
    #get the 2 most recent entries for each device
    $checks = $_.Group | Sort-Object -Property Date -Descending |
        Select-Object -First 2
    #calculate a percent change between the two entries
    "$($checks[0].ComputerName) Drive $($checks[0].DeviceID) had a change of "
} | Out-File @outParams

$header = @"
****************************
Percent Free Average Over Time
"@
$header | Out-File @outParams

foreach ($computer in $all) {
    $stat = $computer.group | Measure-Object -Property PctFree -Average
    "$($computer.name) = $($stat.Average -as [int32])%" | Out-File @outParams
}

#write the report file to the pipeline
Get-Item -Path $OutputPath

#sample usage
# .\DiskReport
#open file to view
