#get disk usage information and export it to a CSV file for trend report
Param(
    [string[]] $ComputerName = $env:COMPUTERNAME
)

#path to CSV file is hard coded
$CSV = "C:\Users\mara_\Desktop\powershell\diskhistory.csv"

#initialize an empty array
$data = @()

#define a hashtable of parameters to splat to get-ciminstance
$cimParams = @{
    ClassName = "Win32_LogicalDisk"
    Filter = "drivetype = 3"
    ErrorAction = "Stop"
}

Write-Host "Getting disk information from $ComputerName" -ForegroundColor Red
foreach ($computer in $ComputerName) {
    Write-Host "Getting disk information from $computer." -ForegroundColor Cyan

    #update the hashtable on the fly
    $cimParams.Computername = $computer
    Try {
        $disk = Get-CimInstance @cimParams

        $data += $disk |
            Select-Object @{Name = "ComputerName"; Expression = {$_.SystemName}},
        DeviceId, Size, FreeSpace, 
        @{Name = "PctFree"; Expression = { ($_.FreeSpace / $_.Size) * 100}},
        @{Name = "Date"; Expression = {Get-Date}}
    } #try
    Catch {
        Write-Warning "Failed to get disk data from $($Computer.toUpper()). $($_.Exception.message)"
    } #catch
} #foreach

#only export if there is comething in $data
if ($data) {
    $data | Export-Csv -Path $CSV -Append -NoTypeInformation
    Write-Host "Disk report complete. See $CSV." -ForegroundColor Green      
}
else{
    Write-Host "No disk data found." -ForegroundColor Yellow
}

