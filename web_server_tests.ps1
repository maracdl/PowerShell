Describe "Check Server Health" {
    Context "Disk Health" {
        it "Disk C has sufficient space" {
            (Get-DiskSpace -Disk "A").SpaceByPercentage | should BeGreaterThan '10'
        }
        it "Disk D has sufficient space" {
            (Get-DiskSpace -Disk "D").SpaceByPercentage | should BeGreaterThan '10'
        }
    }
    Context "Port Status" {
        foreach ($port in $required_ports) {
            it "$port is open" {
                Get-Port $port | should be "Open"
            }
        }
    }
}

Describe "SQL Databases" {
    Context "Check Database Versions" {
        $db_results = Test-CsDatabase -ConfiguredDatabases -SqlServerFqdn $be_servers
        foreach ($db in $db_results) {
            It "$($db.DatabaseName) database version is correct" {
                [string]$installed_db_version = "$($db.InstalledVersion.SchemaVersion).$($db.InstalledVersion.SprocVersion).$($db.InstalledVersion.UpgradeVersion)"
                [string]$expected_db_version = "$($db.ExpectedVersion.SchemaVersion).$($db.ExpectedVersion.SprocVersion).$($db.ExpectedVersion.UpgradeVersion)"
                $installed_db_version | should be $expected_db_version
            }
        }
    }
    Context "Check SQL Ports" {
        $sql_ports = @('1433', '5022', '7022')
        foreach ($port in $sql_ports) {
            it "Server is listening on port $port" {
                $port_state = Invoke-Command -Session $be_session -ScriptBlock { param($port)(Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue).State } -ArgumentList $port
                $port_state.Value -contains "Listen" | should be $true
            }
        }
    }
    Context "Check Mirror Status" {
        $db_state = Get-CsDatabaseMirrorState -PoolFqdn $fe_pools
        foreach ($db in $db_state) {
            it "$($db.DatabaseName) database is on primary" {
                $db.StateOnPrimary -eq "Principal" | should be true
            }
        }
    }
}