# Get this from the PS gallery
# https://www.powershellgallery.com/packages/WindowsCompatibility/1.0.0
Install-Module -Name WindowsCompatibility

#Install-WindowsFeature -Name RSAT-DHCP
Import-WinModule -name dhcpserver
Get-Command -Module dhcpserver

# Lets check that DHCP is running
Get-DhcpServerSetting -ComputerName DC1

# Leases
Get-DhcpServerv4Lease -ComputerName DC1 -ScopeId 10.200.0.0

# Lets look at the existing scopes
Get-DhcpServerv4Scope -ComputerName DC1

# Lets Create a New Scope
$dhcp = @{
    Name         = 'Techsnips'
    StartRange   = '10.1.0.1'
    EndRange     = '10.1.0.100'
    SubnetMask   = '255.255.255.0'
    ComputerName = 'DC1'
  }
  Add-DhcpServerV4Scope @dhcp

# Retrieve the scope
  Get-DhcpServerv4Scope -ComputerName DC1

# Set an option at server level - We'll define the dns server
$dns = @{
    computername = 'DC1'
    dnsserver = '10.200.0.10'
}
Set-DhcpServerV4OptionValue @dns

# Set an option at Scope level - we'll define the dnsdomain name
$dns = @{
  computername = 'DC1'
  scopeid = '10.1.0.0'
  dnsdomain = 'techsnips.internal'
}
Set-DhcpServerV4OptionValue @dns

# Remove a Scope
Remove-DhcpServerv4Scope -ComputerName DC1 -ScopeId 10.1.0.0

# Remove an Option
Remove-DhcpServerv4OptionValue -ComputerName DC1 -OptionId 6