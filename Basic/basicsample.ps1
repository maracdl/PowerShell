#Basic script to view stopped sservice on a system
$ComputerName = Read-Host 'Enter name of hostname'

$StoppedService = Get-Service -ComputerName $ComputerName |
                    Where-Object -Property Status -eq 'Stopped'

Write-Output $StoppedService