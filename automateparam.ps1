#get a breakdown of error sources in the System evetlog
Param(
    [string]$Log = "System",
    [string]$ComputerName = $env:COMPUTERNAME,
    [int32]$Newest = 500,
    [string]$ReportTitle = "Event Log Report",
    [Parameter(Mandatory, HelpMessage = "Enter the path for the HTML file.")]
    [string]$Path
)   

#get event Log data and group it
$data = Get-EventLog -LogName $Log -EntryType Error -Newest $Newest -ComputerName $ComputerName |
    Group-Object -Property Source -NoElement

#create an HTML report
$footer = "<h5><i>Report run $(get-date)</i></h5>"
$precontent = "<h1>$computername</h1><h2>Last $newest error sources from $log</h2>"

$data | Sort-Object -Property Count, Name -Descending |
    Select-Object Count, Name |
    ConvertTo-Html -Title $ReportTitle -PreContent $precontent -PostContent $footer |
    Out-File -FilePath $Path