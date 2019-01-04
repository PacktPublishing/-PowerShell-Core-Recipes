# Use the PS Provider
# Powershell can expose the two main registry keys
Get-PSDrive

Get-PSDrive -PSProvider Registry | Select-Object -Property Name, Root

# Look at Startup items in the Registry
Set-Location -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
Get-Item .
Get-ItemProperty .

# Lets use a variable
$mouse = Get-ItemProperty -path 'HKCU:\Control Panel\Mouse'
$mouse.MouseHoverHeight

# Get Registry Permissions
Get-Acl -Path HKCU:\Software
$rights = Get-Acl -Path HKCU:\Software
$rights.Access.IdentityReference

# Test if a Registry Key exists
Test-Path -Path HKCU:\Software\Microsoft