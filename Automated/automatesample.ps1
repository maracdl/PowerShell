#get a breakdown of error sources in the System eventlog

#start with a command that works in the console
$computername = $env:COMPUTERNAME
$data = Get-EventLog System -EntryType Error -Newest 1000 -ComputerName $computername
Group-Object -Property Source -NoElement

#create an HTML report
$title = "System Log Analysis"
$footer = "<h5>report run $(Get-Date)</h5>"
$css = "http://jdhitsolution.com/sample.css"

$data | Sort-Object -Property count, name -Descending |
Select-Object count, name |
ConvertTo-Html -Title $title -PreContent "<h1>$computername</h1>" -PostContent $footer -CssUri $css |
Out-File C:\Users\mara_\Desktop\powershell\systemsources.HTML

# Invoke-Item C:\Users\mara_\Desktop\powershell\systemsources.HTML