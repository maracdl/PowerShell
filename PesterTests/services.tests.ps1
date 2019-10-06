param(
    $Services = @(
        'DHCP', 'DNSCache', 'Eventlog', 'PlugPlay', 'RpcSs', 'lanmanserver',
        'LmHosts', 'Lanmanworkstation', 'MpsSvc', 'WinRM'
    )
)

Describe 'Operating System' -Tag 'OS' {
    Context 'Service Availability' {

        It 'Eventlog is running' {
            $svc = Get-Service -Name Eventlog
            $svc.Status | Should Be running
        }
    }
}

Describe 'Operating System' -Tag 'OS1' {
    Context 'Service Availability' {

        $Services | ForEach-Object {
            It "[$_] should be running" {
                (Get-Service $_).Status | Should Be running
            }
        }
    }
}