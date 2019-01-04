# Get this from the PS gallery
# https://www.powershellgallery.com/packages/WindowsCompatibility/1.0.0
Install-Module -Name WindowsCompatibility

Import-WinModule -name dnsserver

# Manager Windows Features
Get-Command -Module dnsserver
(Get-Command -Module dnsserver).Count

# Lets look at some commands
Get-DNSserverZone -ComputerName DC1
Get-DNSServerSetting -Computername DC1

# Lets Pull some records
Get-DnsServerResourceRecord -ComputerName dc1 -ZoneName psdevops.local -RRType A

# Lets Add a primary forward lookup zone
$config = @{
    Name              = 'techsnips.internal'
    ReplicationScope  = 'Forest'
    DynamicUpdate     = 'Secure'
    ComputerName      = 'DC1'
}
Add-DnsServerPrimaryZone @config

Get-DNSserverZone -ComputerName DC1

# Lets Add a primary reverse lookup zone
$config = @{
    Name              = '20.20.10.in-addr.arpa'
    ReplicationScope  = 'Forest'
    DynamicUpdate     = 'Secure'
    ComputerName      = 'DC1'
  }
Add-DnsServerPrimaryZone @config

# Lets test the server
Test-DnsServer -ComputerName DC1 -IPAddress 10.200.0.10 -Zonename techsnips.internal

# Lets Add an A record to our new zone
$arec = @{
    ZoneName      =  'techsnips.internal'
    A              =  $true
    CreatePTR      = $true
    Name           = 'app2'
    AllowUpdateAny =  $true
    IPv4Address    = '10.20.20.1'
    ComputerName      = 'DC1'
}
Add-DnsServerResourceRecord @arec

Get-DnsServerResourceRecord -ComputerName DC1 -ZoneName techsnips.internal -Name 'app2' 

# Lets remove the zone
Remove-DnsServerZone -ComputerName DC1 -name techsnips.internal
Remove-DnsServerZone -ComputerName DC1 -name 20.20.10.in-addr.arpa

# Further commands
Get-command -module dnsserver