#OS Description
    $OS = (Get-CimInstance Win32_OperatingSystem -ComputerName MARADIAS).caption
    $OS

#Disk Freespace on OS Drive
    $drive = Get-WmiObject -class Win32_logicaldisk |
                Where-Object DeviceID -EQ 'C:'
    $FreeSpace = (($drive.Freespace)/1gb)
    $drive
    $FreeSpace

#Amount of System Memory
    $MemoryInGB = ((((Get-CimInstance Win32_PhysicalMemory -ComputerName MARADIAS).Capacity | Measure-Object -Sum).Sum)/1gb)
    $MemoryInGB

#Last Reboot of System
    $LastReboot = (get.Get-CimInstance -class Win32_OperatingSystem -ComputerName MARADIAS).LastBootUpTime
    $LastReboot

#IP Address $ DNS Server
    $DNS = Resolve-DnsName -Name MARADIAS | Where-Object Type -EQ "A"
    $DNSName = $DNS.Name
    $DNSIP = $DNS.Ipaddress
    $DNS
    $DNSName
    $DNSIP

#DNS Server of Target
    $CimSession = New-CimSession -ComputerName MARADIAS -Credential (Get-Credential)
    (Get-DnsClientServerAddress -CimSession $CimSession -InterfaceAlias "ethernet" -AddressFamily IPv4).ServerAddresses
    

#Write Output to screen