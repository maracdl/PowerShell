#Simple test
Describe "Connection" {
    
    It "Port 80" {
        Test-NetConnection -Port 80 -InformationLevel "Detailed" | Should not Be $false
    }   
}

Describe "Running service" {

    $PcName = "MARADIAS"
    $status = (Get-Service -ComputerName $PcName -Name 'WebClient').Status

    It "should be running" {
        $status | Should Be 'Running'
    }
}

#invoke test and generates report
Invoke-Pester -Path C:\Users\mara_\Desktop\powershell\SamplePesterReport.Tests.ps1 -OutputFormat  NUnitXml -OutputFile C:\temp\Tests.xml

#open report
C:\ReportUnit.exe C:\Results C:\