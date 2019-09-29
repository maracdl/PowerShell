param(
    $Services = @(
        'DHCP', 'DNSCache', 'Eventlog', 'PlugPlay', 'RpcSs', 'lanmanserver',
        'LmHosts', 'Lanmanworkstation', 'MpsSvc', 'WinRM'
    )
)

describe 'Operating System' {
    context 'Service Availability' {
        it 'Eventlog is running' {
            $svc = Get-Service -Name Eventlog
            $svc.Status | Should Be running
        }
    }
}

describe 'Operating System' {
    context 'Service Availability' {
        $Services | ForEach-Object {
            it "[$_] should be running" {
                (Get-Service $_).Status | Should Be running
            }
        }
    }
}