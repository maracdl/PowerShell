#Step1 Run HardCoded command
Get-Service -ComputerName MARADIAS |
                Where-Object -Property Status -EQ 'Stopped'

#Step2 Add variables
$ComputerName = "MARADIAS"

Get-Service -ComputerName $ComputerName |
                Where-Object -Property Status -EQ 'Running'

#Step3 Parmeterize Variable
#Parameter help description
param (
    [Parameter(Mandatory=$True)]
    [string[]]
    $ComputerName
)

#Enter script block here
Get-Service -ComputerName $ComputerName |
                Where-Object -Property Status -EQ 'Running'

#Step4 Add Logic
param (
    [Parameter(Mandatory=$True)]
    [string[]]
    $ComputerName
)

#Loop through each computer parameter, and perform action in code block
foreach ($target in $ComputerName){

    #Enter code block here and change variable to match condition
    Get-Service -ComputerName $ComputerName |
                Where-Object -Property Status -EQ 'Stopped'
}
