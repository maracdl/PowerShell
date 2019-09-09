#Script displays the status of of services running in a specified machine

#Creates a mandatory parameter for ComputerName and for Service Status
Param (
    [Parameter(Mandatory=$true)]    # Parameter help description
    [string[]]                      #Additional [] after string denotes this parameter accepts multiple inputs
    $ComputerName                   #Note this is the same as the variable used in your code below
)

#Creates a variable for Get-Service Objects
#As it can hold multiple objects, referred to as an array
$Services = Get-Service -ComputerName $ComputerName

#Use foreach construct to perform actions on each object in $Services
foreach ($service in $services) {

    #Create variable containing status and displayname using member enumeration
    $ServiceStatus = $service.Status            #decimal notating the variable allows access to properties of each object

    $ServiceDisplayName = $Service.displayname

    #Use if-else construct for decision making
    if ($ServiceStatus -eq 'Running') {
        Write-Output "Service OK - Status of $ServiceDisplayName is $ServiceStatus"
    }
    else {
        Write-Output "Check Service - Status of $ServiceDisplayName is $ServiceStatus"
    }

}
    