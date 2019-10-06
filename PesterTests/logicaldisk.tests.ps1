param(
    $FreeSystemDriveMBytesThreshold = 500,
    $FreeSystemDrivePctThreshold = .05,
    $FreeNonSystemDriveMBytesThreshold = 1000,
    $FreeNonSystemDrivePctThreshold = .05
)

Describe 'Logical Disks' {

    $vols = Get-Volume | Where-Object { $_.DriveType -eq 'Fixed' -and -not [string]::IsNullOrEmpty($_.DriveLetter) }
    Context 'Availablity' {
        $vols | ForEach-Object {
            It "Volume [$($_.DriveLetter)] is healthy" {
                $_.HealthStatus | Should Be 'Healthy'
            }
        }
    }

    Context 'Capacity' {
        $systemDriveLetter = $env:SystemDrive.Substring(0, 1)
        $sysVol = $vols | Where-Object DriveLetter -eq $systemDriveLetter
        $nonSysVols = $vols | Where-Object DriveLetter -ne $systemDriveLetter

        It "System drive [$systemDriveLetter] has $FreeSystemDriveMBytesThreshold MB and $('{0:p0}' -f $FreeSystemDrivePctThreshold) free" {
            ($sysVol.SizeRemaining / 1MB) -ge $FreeSystemDriveMBytesThreshold | Should Be $true
            ($sysVol.SizeRemaining / $sysVol.Size) -ge $FreeSystemDriveThresholdPct | Should Be $true
        }

        Foreach ($volume in $nonSysVols) {
            $driveLetter = $volume.DriveLetter
            It "Non-System drive [$driveLetter] has greater than $FreeNonSystemDriveMBytesThreshold MB and $('{0:p0}' -f $FreeNonSystemDrivePctThreshold) free" {
                ($volume.SizeRemaining / 1MB) -ge $FreeNonSystemDriveThreshold | Should Be $true
                ($volume.SizeRemaining / $volume.Size) -ge $FreeNonSystemDriveThresholdPct | Should Be $true
            }
        }
    }
}